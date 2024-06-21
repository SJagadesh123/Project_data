--Create Tables of Appraisal Company
CREATE TABLE mpa.appraisal_company (
  amc_id SERIAL PRIMARY KEY,
  amc_reg_id CHARACTER VARYING(10) NOT NULL UNIQUE, -- Registration ID (unique identifier)
  amc_name CHARACTER VARYING(60) NOT NULL UNIQUE,  -- Company Name (unique identifier)
  address VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(50) NOT NULL,
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') NOT NULL, -- Enforces US zip code format
  country VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(100) UNIQUE NOT NULL,  -- Ensures unique email addresses
  website VARCHAR(255) UNIQUE,
  notes TEXT,				-- some writeup about the appraisal company
  
  --fields added on 19th March
  appraisal_methodology TEXT, -- Description of the methodology used by the appraisal company to determine property values (some follow comparable sales approach, some follow income approach etc)
  valu_low_limit DECIMAL(18,2) -- Lower limit of the property valuation that will be taken up
);

COMMENT ON TABLE mpa.appraisal_company IS 'Appraisal Company master data';

CREATE TABLE mpa.appraisal_service_area (
  appraisal_area_id SERIAL PRIMARY KEY,
  amc_id INTEGER REFERENCES mpa.appraisal_company(amc_id) NOT NULL,  -- Foreign key to appraisal_company table
  county VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(50) NOT NULL,
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') -- Enforces US zip code format
  
);

COMMENT ON TABLE mpa.appraisal_service_area IS 'Areas in which services are provided by an Appraisal Company.';

CREATE TABLE mpa.appraisal_property_types (
    prop_type_id SERIAL PRIMARY KEY,
    prop_type_name VARCHAR(100) NOT NULL
);

COMMENT ON TABLE mpa.appraisal_property_types IS 'Master data related to property types';

CREATE TABLE mpa.appraisal_company_property_type (
	amc_id	INTEGER,
	prop_type_id INTEGER,
	PRIMARY KEY (amc_id, prop_type_id), 
	FOREIGN KEY (amc_id) REFERENCES mpa.appraisal_company(amc_id), 
	FOREIGN KEY (prop_type_id) REFERENCES mpa.appraisal_property_types(prop_type_id)
);
COMMENT ON TABLE mpa.appraisal_property_types IS 'Junction table for Appraisal Company & Property Type';

CREATE TABLE mpa.property_appraiser (
  appraiser_id SERIAL PRIMARY KEY,
  appraiser_licence_id VARCHAR(10) NOT NULL UNIQUE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,  -- Ensures unique email addresses
  phone VARCHAR(20) UNIQUE NOT NULL,
  amc_id INTEGER REFERENCES mpa.appraisal_company(amc_id) NOT NULL,  -- Foreign key to appraisal_company table 
  
  -- field added on 19th March
  expert_witness_testimony BOOLEAN -- does this appraiser work on Expert witness testimony service or not
);
COMMENT ON TABLE mpa.property_appraiser IS 'Property Appraiser master data.';

--inserting data into the appraisal company

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email, website, notes, appraisal_methodology, valu_low_limit)
VALUES ('AGZ001', 'ABC Appraisal Services', '123 Main St', 'Anytown', 'CA', '12345', 'USA', '123-456-7890', 'info@abcappraisal.com', 'www.abcappraisal.com', 'ABC Appraisal Services specializes in residential properties.','Combining market comps, income potential, and rebuild cost for property value.', 75000);

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email, website, notes, appraisal_methodology, valu_low_limit)
VALUES ('RJE002', 'XYZ Appraisal Consultants', '456 Elm St', 'Sometown', 'TX', '54321', 'USA', '987-654-3210', 'contact@xyzappraisal.com', 'www.xyzappraisal.com', 'XYZ Appraisal Consultants provides commercial and industrial appraisal services.','Appraisal considers recent sales, income generation, and replacement cost.', 120000);

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email, website, notes, appraisal_methodology, valu_low_limit)
VALUES ('RKN003', 'AppraiseIt Inc.', '789 Oak St', 'AnotherCity', 'CA', '67890', 'USA', '456-789-1234', 'appraiseit@example.com', 'www.appraiseit.com', 'AppraiseIt Inc. has over 20 years of experience in the appraisal industry.','Fair market value estimated through comparable sales, income approach, and cost to replace.',95000);

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email, website, notes)
VALUES ('DRJ123', 'Reliable Appraisals Inc.', '123 Main St', 'Anytown', 'CA', '12346', 'USA', '555-555-5555', 'info@reliableappraisals.com', 'https://reliableappraisals.com', 'Specializes in residential appraisals');

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email)
VALUES ('FRL456', 'Quick Value Appraisals', '456 Elm St Suite 200', 'Anycity', 'TX', '78012', 'USA', '888-888-8888', 'quickvalue@appraisals.com');

INSERT INTO mpa.appraisal_company (amc_reg_id, amc_name, address, city, state, zipcode, country, phone, email, website, notes)
VALUES ('GFR789', 'Honest Appraisals', '789 Maple Ave', 'Sometown', 'NY', '10001', 'USA', '999-999-9999', 'honest@appraisal.com', NULL, 'We offer fast and accurate appraisals.');


--inserting data into the property types
INSERT INTO mpa.appraisal_property_types (prop_type_name) 
VALUES
    ('Single Family Residence'),
    ('Condominium'),
    ('Townhouse'),
    ('Multi-Family Residence'),
    ('Vacant Land'),
    ('Commercial Property'),
    ('Industrial Property');

--inserting data into the appraisal company service areas
INSERT INTO mpa.appraisal_service_area (amc_id, county, city, state, zipcode) 
VALUES 
  (1, 'Los Angeles County', 'Los Angeles', 'California', '90001'),
  (1, 'San Francisco County', 'San Francisco', 'California', '94102'),
  (2, 'Cook County', 'Chicago', 'Illinois', '60601'),
  (2, 'Kings County', 'Brooklyn', 'New York', '11201'),
  (3, 'Harris County', 'Houston', 'Texas', '77001'),
  (4, 'Miami-Dade County', 'Miami', 'Florida', '33101'),
  
 --inserting data into the appraisal company property type
INSERT INTO mpa.appraisal_company_property_type(amc_id, prop_type_id)
VALUES
	(1,3),
	(1,5),
	(2,4),
	(4,1),
	(4,2),
	(4,6);

--inserting data into the appraisal company
INSERT INTO mpa.property_appraiser (appraiser_licence_id, first_name, last_name, email, phone, amc_id, expert_witness_testimony) 
VALUES 
  ('APL001', 'John', 'Doe','john.doe@example.com', '+1234567890', 1, true),
  ('APL002', 'Jane', 'Smith', 'jane.smith@example.com', '+1987654321', 2, false),
  ('APL003', 'Michael', 'Johnson', 'michael.johnson@example.com', '+1122334455', 1, true),
  ('APL004', 'Emily', 'Davis', 'emily.davis@example.com', '+1555666777', 3, false),
  ('APL005', 'Christopher', 'Brown', 'chris.brown@example.com', '+1888999000', 2, true),
  ('APL006', 'Jessica', 'Wilson', 'jessica.wilson@example.com', '+1777888999', 1, false),
  ('APL007', 'David', 'Martinez', 'david.martinez@example.com', '+1666777888', 3, true),
  ('APL008', 'Sarah', 'Anderson', 'sarah.anderson@example.com', '+1999888777', 2, false); 
