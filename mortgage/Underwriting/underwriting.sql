CREATE TABLE mpa.underwriting_company (
    uwco_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$'), -- Enforces US zip code format
    country VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    notes TEXT,			-- Notes about the underwriting company
	
	-- fields added on 19th march
	uw_claim_process TEXT -- Details about the process followed by the underwriting company for handling insurance claims
);
COMMENT ON TABLE mpa.underwriting_company IS 'underwriting company master data';

INSERT INTO mpa.underwriting_company (name, address, city, state, zipcode, country, phone, email, website, notes, uw_claim_process) 
VALUES 
('Edge Underwriters Group', '123 Main St', 'Wattson Town', 'CA', '12345', 'USA', '123-456-7890', 'info@abcunderwriters.com', 'www.edgeuwgrp.com', 'Provides underwriting services for residential mortgages.', 'Efficiently assess claims, providing prompt support and fair resolutions for policyholders and stakeholders alike.'),
('NewRez Mortgage Services', '456 Oak St', 'Shania Town', 'NY', '54321', 'USA', '987-654-3210', 'info@xyzmortgageservices.com', 'www.newrezmortgageservices.com', 'Specializes in FHA and VA loan underwriting.','Comprehensive claim management, employing advanced technology, experienced professionals, and ethical practices to deliver optimal outcomes for all parties involved.'),
('Sunrise Lending Solutions', '789 Elm St', 'Any city', 'TX', '67890', 'USA', '555-123-4567', 'info@sunriselending.com', 'www.sunriselending.com', 'Offers underwriting services for both residential and commercial mortgages.','Comprehensive claim management, employing advanced technology, experienced professionals, and ethical practices to deliver optimal outcomes for all parties involved.'),
('Capital Underwriting Group', '321 Maple Ave', 'Othertown', 'FL', '13579', 'USA', '333-777-9999', 'info@capitalunderwriting.com', 'www.capitalunderwriting.com', 'Focuses on underwriting jumbo mortgages.','Streamlined claim handling, emphasizing clear communication, meticulous evaluation, and swift resolution to uphold trust and reliability in insurance services.'),
('Midwest Mortgage Underwriters', '101 Pine St', 'Somewhere', 'IL', '24680', 'USA', '222-444-6666', 'info@midwestmortgage.com', 'www.midwestmortgage.com', 'Provides underwriting services for rural development loans.','Thoroughly investigate claims, ensuring accuracy, transparency, and timely processing while prioritizing customer satisfaction and adherence to industry standards.'),
('Coastal Home Loans', '777 Beach Blvd', 'Seaside', 'CA', '98765', 'USA', '888-222-5555', 'info@coastalhomeloans.com', 'www.coastalhomeloans.com', 'Offers underwriting services for vacation and second home mortgages.','Streamlined claim handling, emphasizing clear communication, meticulous evaluation, and swift resolution to uphold trust and reliability in insurance services.'),
('National Mortgage Services', '555 Market St', 'Metroville', 'WA', '54321', 'USA', '777-888-1111', 'info@nationalmortgageservices.com', 'www.nationalmortgageservices.com', 'Provides underwriting services for various loan programs including conventional, FHA, and VA.','Thoroughly investigate claims, ensuring accuracy, transparency, and timely processing while prioritizing customer satisfaction and adherence to industry standards.'),
('Summit Funding Group', '888 Summit Ave', 'Mountain Town', 'CO', '24680', 'USA', '999-000-3333', 'info@summitfundinggroup.com', 'www.summitfundinggroup.com', 'Specializes in underwriting investment property mortgages.','some text blah blah blah'),
('Golden Gate Underwriters', '999 Bridge St', 'Bridge City', 'CA', '13579', 'USA', '777-999-2222', 'info@goldengateunderwriters.com', 'www.goldengateunderwriters.com', 'Focuses on underwriting condominium mortgages in urban areas.','some text blah blah blah'),
('Heartland Underwriting Services', '444 Heartland Blvd', 'Heartland', 'KS', '67890', 'USA', '111-333-5555', 'info@heartlandunderwriting.com', 'www.heartlandunderwriting.com', 'Provides underwriting services for manufactured home loans.','some text blah blah blah');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE mpa.underwriting_criteria (
    criteria_id SERIAL PRIMARY KEY,
    -- uwco_id INT,
    criteria_name VARCHAR(100),
    notes TEXT
    
);
COMMENT ON TABLE mpa.underwriting_criteria IS 'underwriting criteria master data';


INSERT INTO mpa.underwriting_criteria (criteria_name, notes) 
VALUES 
('Credit Score Requirement', 'Minimum required credit score for loan approval.'),
('Debt-to-Income Ratio', 'Maximum allowable debt-to-income ratio for loan approval.'),
('Loan-to-Value Ratio', 'Maximum allowable loan-to-value ratio for loan approval.'),
('Employment Verification', 'Verification of borrower employment status.'),
('Reserve Requirements', 'Minimum required reserves for loan approval.'),
('Property Type Eligibility', 'Eligible property types for loan approval.'),
('Title Search Requirement', 'Requirement for a title search to verify property ownership.'),
('Appraisal Requirement', 'Requirement for an appraisal to determine property value.'),
('Insurance Coverage Requirement', 'Requirement for hazard insurance coverage on the property.'),
('Income Documentation Requirement', 'Documentation required to verify borrower income.');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE mpa.underwriting_criteria_loan_prod (
	prod_id INT, -- primary key from loan-product table of loan-product microservice. we ensure this relation from application tier
	criteria_id INT, 
	PRIMARY KEY (prod_id, criteria_id),
	FOREIGN KEY (criteria_id) REFERENCES mpa.underwriting_criteria(criteria_id)
);
COMMENT ON TABLE mpa.underwriting_criteria_loan_prod IS 'Junction table for underwriting criteria and loan product';

INSERT INTO mpa.underwriting_criteria_loan_prod (prod_id, criteria_id)
VALUES
    (10001, 1), 
    (10001, 4), 
    (10002, 3), 
    (10002, 5), 
    (10002, 9), 
    (10003, 1), 
    (10003, 3);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE mpa.underwriting_service_area (
  service_area_id SERIAL PRIMARY KEY,
  uwco_id INTEGER REFERENCES mpa.underwriting_company(uwco_id) NOT NULL,  -- Foreign key to underwriting_company table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') -- Enforces US zip code format
);

COMMENT ON TABLE mpa.underwriting_service_area IS 'Service areas of an Underwriting company';

INSERT INTO mpa.underwriting_service_area (uwco_id, county, city, state, zipcode) 
VALUES 
    (1, 'Monroe County', 'Rochester', 'NY', '10001'),
    (1, 'Kings County', 'Albany', 'NY', '10002'),
    (2, 'Essex County', 'Newark', 'NJ', '07001'),
    (3, 'Miami-Dade Count', 'Miami', 'FL', '33001');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE mpa.underwriting_history (
    history_id SERIAL PRIMARY KEY,
    uwco_id INT,
    loan_id INT,				-- loan_id should have FK with loan table which has loan data of historical transactions and not current transactions ( loan_history table - not being covered here, hence no Foreign Key is being set)
    decision VARCHAR(50),
    decision_date DATE,
    notes TEXT,
    CONSTRAINT fk_company
        FOREIGN KEY (uwco_id)
        REFERENCES mpa.underwriting_company(uwco_id)
        ON DELETE CASCADE
);
COMMENT ON TABLE mpa.underwriting_history IS 'Historical data of underwriting companies';

INSERT INTO mpa.underwriting_history (uwco_id, loan_id, decision, decision_date, notes) 
VALUES 
(10, 1001, 'Approved', '2002-03-01', 'Loan approved based on satisfactory credit score and debt-to-income ratio.'),
(8, 1002, 'Denied', '2002-03-02', 'Loan denied due to high loan-to-value ratio.'),
(3, 1003, 'Approved', '2002-03-03', 'Loan approved with verification of borrower employment.'),
(10, 1004, 'Approved', '2003-03-04', 'Loan approved with sufficient reserves.'),
(7, 1005, 'Denied', '2003-03-05', 'Property type ineligible for loan approval.'),
(3, 1006, 'Approved', '2003-03-06', 'Title search conducted with no issues found.'),
(1, 1007, 'Approved', '2003-03-07', 'Appraisal value met requirements for loan approval.'),
(8, 1008, 'Denied', '2004-03-08', 'Hazard insurance coverage not sufficient.'),
(7, 1009, 'Approved', '2004-03-09', 'Borrower income verified with required documentation.'),
(1, 1010, 'Denied', '2004-03-10', 'Loan denied due to inability to verify borrower income.');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE mpa.underwriter (
  underwriter_id SERIAL PRIMARY KEY,
  underwriter_licence_id VARCHAR(10) NOT NULL UNIQUE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  license_number VARCHAR(50),  -- Optional field for Underwriter license number
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  phone VARCHAR(20),
  uwco_id INTEGER REFERENCES mpa.underwriting_company(uwco_id) NOT NULL,  -- Foreign key to underwriting_company table
  
  -- field added on 19th March
  liability_insu TEXT -- Details about the liability insurance coverage provided by the underwriter
);
COMMENT ON TABLE mpa.underwriter IS 'Underwriter master data.';

INSERT INTO mpa.underwriter (appraiser_licence_id, first_name, last_name, license_number, email, phone, uwco_id, liability_insu) 
VALUES 
    ('A123456', 'Carl', 'Sagan', 'UW123', 'carl.sagan@example.com', '555-123-4567', 1, 'Comprehensive liability coverage to protect against potential risks, ensuring financial security and peace of mind.'),
    ('B789012', 'Philip', 'Khotler', 'UW456', 'philip.khotler@example.com', '555-987-6543', 2, 'Robust liability insurance shields assets from legal liabilities, offering financial protection and risk mitigation.'),
    ('C345678', 'Michael', 'Doe', NULL, 'michael.doe@example.com', '555-555-5555', 3, 'Reliable liability coverage safeguards against unforeseen events, providing financial security and legal defense assistance.');
