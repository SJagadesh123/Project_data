-- Query to get comments stored about different db tables in a schema
SELECT
    c.relname AS table_name,
    d.description AS table_comment
FROM
    pg_class c
LEFT JOIN
    pg_description d ON c.oid = d.objoid  -- pg_description is a catalog view in Postgres
WHERE
    c.relkind = 'r' -- Only select regular tables
    AND c.relname NOT LIKE 'pg_%' -- Exclude system tables
    AND d.objsubid = 0; -- Table-level comments


-- In the Postgres Database create a Schema for MPA (Mortgage Process Accelerator)
CREATE SCHEMA IF NOT EXISTS MPA;

/*
  There has to be table(s) for application users, storing uid and pwd (in encrypted format)
  
  Tables are broadly classified in to below categories
  1. User table for Application users
  
  2. Loan Products Tables
  -- For each company/partner type there will be company table and service_area table
  3. Escrow Company Tables
  4. Appraisal Managemnt Company Tables
  5. Underwriting Company Tables
  6. Survey Company
  
  
  7. Title Cos 
  8. Property Inspection Cos
  9. Flood Certification Cos
  10. Mortgage Insurance Cos
  11. Document Preparation Cos

NOTE: Bulk uploads are handled by RPA team which uses UiPath.  

Clients:

PennyMac Mortgage Services
~~~~~~~~~~~~~~~~~~~~~~~
PennyMac Mortgage Services, Inc. is an American residential mortgage company headquartered in Westlake Village, California. The company's business focuses on the production and servicing of U.S. mortgage loans and the management of investments related to the U.S. mortgage market.

Caliber Home Loans 
~~~~~~~~~~~~~~~~
Caliber Home Loans is a mortgage banking company, headquartered in Irving, Texas. It is part of NewRez Group of Companies. Caliber Home Loans focuses solely on mortgages.

** Application Requirement:**  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Stage-1: Develop the API end points to perform CRUD-Q operations for different types of master data like Loan Products, Escrow Cos, Underwriting Cos, Appraisal Cos, Survey Cos etc.

Stage-2: Develop the required "Responsive web UI" with React JS and integrate it with the API end points

Search Functionalities (Q):
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Loan Products by:
	Product Id
	Loan Term
	Credit score
	PMI required
	Restriction category & Restriction type
	Escrow requirements

Search functionality for Loan Products based on pre-pay penalty:	
	Pre-pay penalty info by prod_id. 
	List of products with Pre-pay penalty which are currently active
	List of products without Pre-pay penalty which are currently active

Search functioinality for different vendor types by: 	Id / Name / City / State / Zip Code
	
*/

---x-- Tables related to Loan Products - START  --x---

CREATE TABLE mpa.prop_rstr_catg 
(
	catg_id SERIAL PRIMARY KEY, -- Restriction Category ID
	catg_type CHARACTER VARYING(35) NOT NULL,
	catg_desc CHARACTER VARYING(300) NOT NULL
);

COMMENT ON TABLE mpa.prop_rstr_catg IS 'Property rstriction Catogeries';

----------------
-- Between prop_rstr_catg & prop_rstr there exists 1-to-M relation
CREATE TABLE mpa.prop_rstr
(
	rstr_id SERIAL PRIMARY KEY, --restriction ID
	rstr_catg_id INTEGER NOT NULL,
	rstr_type CHARACTER VARYING(30) NOT NULL,
	rstr_desc CHARACTER VARYING(300) NOT NULL,
	
	CONSTRAINT "FK_PROP_rstr_CATEGORY" FOREIGN KEY (rstr_catg_id)
        REFERENCES mpa.prop_rstr_catg (catg_id)
);

COMMENT ON TABLE mpa.prop_rstr_catg IS 'Property rstrictions for Mortgage';

----------------

CREATE SEQUENCE mpa.loan_prod_seq START 10001;

CREATE TABLE mpa.loan_prod
(
	prod_id INTEGER DEFAULT NEXTVAL('mpa.loan_prod_seq') PRIMARY KEY,
	prod_name CHARACTER VARYING(50) NOT NULL,
	intr_rate DECIMAL(5,2) NOT NULL,			-- interest rate applicable for loan
	loan_term INTEGER NOT NULL,              -- period of time, in months,  within which a loan is expected to be repaid
	max_loan_amt DECIMAL(18,2) NOT NULL,
	mdp DECIMAL(18,2) NOT NULL,              -- Min Down Payment, interpret this w.r.t mdp_type
	mdp_type CHARACTER VARYING(10) NOT NULL,  -- Value can be either ABSOLUTE or PERCENTAGE - see Check constraint 
	min_cr_score INTEGER NOT NULL,           -- Min required credit score for the loan product
	max_ltv_ratio INTEGER NOT NULL,			 -- Max Loan-to-Value ratio 
	pmi_req BOOLEAN NOT NULL,				 -- Private Mortgage Insurance required
	orgin_fee DECIMAL(18,3) NOT NULL,        -- Origination fee
	prepay_penalty BOOLEAN NOT NULL,		 -- is pre payment penalty applicable to the loan product
	docu_reqrm CHARACTER VARYING(500) NOT NULL,  -- Documentation requirements - free text
	escrow_req BOOLEAN NOT NULL,				-- Is Escrow required for the loan product
  	prop_rstr_exists BOOLEAN NOT NULL,			-- Do Property restrictions exist for the loan product
	status BOOLEAN NOT NULL,  				-- If true the loan product is currently Active else Inactive

	CONSTRAINT mdp_types CHECK(mdp_type = 'ABSOLUTE' OR
							   mdp_type = 'PERCENTAGE')
);

COMMENT ON TABLE mpa.loan_prod IS 'Loan Products';

/*
mdp_type = ABSOLUTE => Actual amount of Min down payment
mdp_type = PERCENTAGE => Min down payment is expressed as a percentage of actual loan amount
-- Actual loan amount will be captured in Loan Approval table which will be part of Loan Origination module and not part of Master Data Processing module.

-- Handling Penalty clause master data for delay in loan repayment for each loan product can be handled later on. It is part of this module
*/

-- Table to establish many-to-many relation between loan_prod and prop_rstr tables
CREATE TABLE mpa.loan_prod_prop_rstr
(
	prod_id INTEGER,
	rstr_id INTEGER,
	CONSTRAINT loan_prod_prop_rstr_pk PRIMARY KEY(prod_id, rstr_id),
	CONSTRAINT "fk_loan_prod_id" FOREIGN KEY (prod_id)
        REFERENCES mpa.loan_prod(prod_id),
	CONSTRAINT "fk_prop_rstr_id" FOREIGN KEY (rstr_id)
        REFERENCES mpa.prop_rstr(rstr_id)
);

COMMENT ON TABLE mpa.loan_prod_prop_rstr IS 'Junction table for Loan Products & Property Restrictions';

-- Product status history to be tracked in table "loan_prod_status_history" ( prod_id (pk, fk), st_date (pk), end_date NOT NULL  ( user_id (fk) - NOT taken care for now
-- loan_prod to loan_prod_status_history has 1-to-M relation
CREATE TABLE mpa.loan_prod_status_history
(
	prod_id INTEGER NOT NULL,
	start_dt DATE NOT NULL,
	end_dt DATE NOT NULL,
	
	CONSTRAINT "PROD_STATUS_HIST_PK" PRIMARY KEY (prod_id, start_dt),
	CONSTRAINT "PROD_ID_FK1" FOREIGN KEY (prod_id)
        REFERENCES mpa.loan_prod(prod_id),
	CONSTRAINT "ST_DATE_CHK" CHECK (end_dt > start_dt)
);

COMMENT ON TABLE mpa.loan_prod_status_history IS 'Timelines for loan product being Active or Inactive';

/*
NOTE: mpa.loan_prod_status_history - In the application layer it should be taken care that for a given prod_id start_dt cannot be on or before any of the same prod_id's already existing end_dt.  This is necessary to avoid overlaping active/inactive periods for any product.

If start_dt & end_dt are same in an entry => the loan product was active for just one day
*/



--mpa.pre_pay_penalty_master table script added on 22nd March
CREATE TABLE mpa.pre_pay_penalty_master
(
	penalty_id SERIAL PRIMARY KEY,  
	prod_id INTEGER UNIQUE NOT NULL,   -- UNIQUE because of 1-to-1 relation with loan_prod table
	min_penalty_amt DECIMAL(18,2) NOT NULL,
	penalty_percentage DECIMAL(5,2) NOT NULL, -- value should be between 0 and 100
	CONSTRAINT "PROD_ID_penm" FOREIGN KEY (prod_id)
        REFERENCES mpa.loan_prod(prod_id)
);

COMMENT ON TABLE mpa.pre_pay_penalty_master IS 'Master data related to pre-pay penalty of loan product';

-- NOTE: There should be a table for repay_delay_penalty_master.  Can be taken up later on.

---x-- Tables related to Loan Products - END  --x---


---x-- Tables related to Escrow - START  --x---
CREATE TABLE mpa.escrow_companies (
    esco_id SERIAL PRIMARY KEY,
    esco_name CHARACTER VARYING(60),
    address CHARACTER VARYING(255),
    city CHARACTER VARYING(100),
    state CHARACTER VARYING(100),
    zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$'), -- Enforces US zip code format,
    phone CHARACTER VARYING(20),
    email CHARACTER VARYING(60),
	
	-- fields added on 19th March
	in_escrow_ac_no CHARACTER VARYING(20),    -- A/c info of the escrow co's holding a/c where funds are temporarily deposited
	es_ac_bank_name CHARACTER VARYING(20),    -- Name of Bank in which escrow a/c is present
	es_process_time INTEGER -- measured in days. It's an aveg of co's performance. Usually the aveg ranges between 20 working days to 30 working days 
	
);
COMMENT ON TABLE mpa.escrow_companies IS 'Master data of Escrow companies';

CREATE TABLE mpa.escrow_requirements ( 
	req_id SERIAL PRIMARY KEY, 
	req_name CHARACTER VARYING(100), 
	description TEXT
);

COMMENT ON TABLE mpa.escrow_requirements IS 'Master data of different types of Escrow requirements';


CREATE TABLE mpa.escrow_requirements_loan_prod ( 
	prod_id INT, 
	req_id INT, 
	PRIMARY KEY (prod_id, req_id), 
	FOREIGN KEY (prod_id) REFERENCES mpa.loan_prod(prod_id), 
	FOREIGN KEY (req_id) REFERENCES mpa.escrow_requirements(req_id)
);
COMMENT ON TABLE mpa.escrow_requirements IS 'Junction table to set M-2-M relation between escrow requirements and loan products';

CREATE TABLE mpa.escrow_service_area (
  service_area_id SERIAL PRIMARY KEY,
  esco_id INTEGER REFERENCES mpa.escrow_companies(esco_id) NOT NULL,  -- Foreign key to escrow_companies table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') -- Enforces US zip code format
  -- CHECK (zipcode SIMILAR TO '[0-9]{5}(?:[-][0-9]{4})?')  
);

COMMENT ON TABLE mpa.escrow_service_area IS 'Service areas of an Escrow company';

CREATE TABLE mpa.escrow_agent (
  escrow_agent_id SERIAL PRIMARY KEY,
  escrow_licence_id VARCHAR(10) NOT NULL unique
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  license_number VARCHAR(50),  -- Optional field for Escrow Agent license number
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  phone VARCHAR(20),
  esco_id INTEGER REFERENCES mpa.escrow_companies(esco_id) NOT NULL,  -- Foreign key to escrow_companies table
  
  -- fileds added on 19th March
  avg_tx_vol  INTEGER, -- Average number of transactions handled by the escrow agent on montly basis
  tx_success_rate DECIMAL (5,2), -- Success rate based on montly average
  escrow_sw VARCHAR(50)   -- Escrow software used by the agent (Eg: Qualia, E-Closing, SnapClose, ResWare etc.)
);
COMMENT ON TABLE mpa.escrow_agent IS 'Escrow Agent master data.';

---x-- Tables related to Escrow - END  --x---

---x-- Tables related to Underwriting - START  --x---

CREATE TABLE mpa.underwriting_company (
    uwco_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
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

CREATE TABLE mpa.underwriting_criteria (
    criteria_id SERIAL PRIMARY KEY,
    -- uwco_id INT,
    criteria_name VARCHAR(100),
    notes TEXT
    /*CONSTRAINT fk_company
        FOREIGN KEY (uwco_id)
        REFERENCES mpa.underwriting_company(uwco_id)
        ON DELETE CASCADE */
);
COMMENT ON TABLE mpa.underwriting_criteria IS 'underwriting criteria master data';

-- NOTE: Underwriting criteria will have relation with Loan Product and not Underwriting Company
CREATE TABLE mpa.underwriting_criteria_loan_prod (
	prod_id INT, 
	criteria_id INT, 
	PRIMARY KEY (prod_id, criteria_id), 
	FOREIGN KEY (prod_id) REFERENCES mpa.loan_prod(prod_id), 
	FOREIGN KEY (criteria_id) REFERENCES mpa.underwriting_criteria(criteria_id)
);
COMMENT ON TABLE mpa.underwriting_criteria_loan_prod IS 'Junction table for underwriting criteria and loan product';

CREATE TABLE mpa.underwriting_service_area (
  service_area_id SERIAL PRIMARY KEY,
  uwco_id INTEGER REFERENCES mpa.underwriting_company(uwco_id) NOT NULL,  -- Foreign key to underwriting_company table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') -- Enforces US zip code format
);

COMMENT ON TABLE mpa.underwriting_service_area IS 'Service areas of an Underwriting company';

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

CREATE TABLE mpa.underwriter (
  underwriter_id SERIAL PRIMARY KEY,
  appraiser_licence_id VARCHAR(10) NOT NULL,
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

---x-- Tables related to Underwriting - END  --x---

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

---x-- Tables related to Appraisal Management Company (AMC) - START  --x---
CREATE TABLE mpa.appraisal_company (
  amc_id SERIAL PRIMARY KEY,
  amc_reg_id CHARACTER VARYING(10) NOT NULL UNIQUE, -- Registration ID (unique identifier)
  amc_name CHARACTER VARYING(60) NOT NULL UNIQUE,  -- Company Name (unique identifier)
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$'), -- Enforces US zip code format
  country VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  website VARCHAR(255),
  notes TEXT,				-- some writeup about the appraisal company
  
  --fields added on 19th March
  appraisal_methodology TEXT, -- Description of the methodology used by the appraisal company to determine property values (some follow comparable sales approach, some follow income approach etc)
  valu_low_limit DECIMAL(18,2)  -- Lower limit of the property valuation that will be taken up
);

COMMENT ON TABLE mpa.appraisal_company IS 'Appraisal Company master data';

CREATE TABLE mpa.appraisal_service_area (
  appraisal_area_id SERIAL PRIMARY KEY,
  amc_id INTEGER REFERENCES mpa.appraisal_company(amc_id) NOT NULL,  -- Foreign key to appraisal_company table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipco de ~ '^([0-9]{5})?$') -- Enforces US zip code format
  
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
  appraiser_licence_id VARCHAR(10) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  license_number VARCHAR(50),  -- Optional field for Property Appraiser license number
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  phone VARCHAR(20),
  amc_id INTEGER REFERENCES mpa.appraisal_company(amc_id) NOT NULL,  -- Foreign key to appraisal_company table 
  
  -- field added on 19th March
  expert_witness_testimony BOOLEAN -- does this appraiser work on Expert witness testimony service or not
);
COMMENT ON TABLE mpa.property_appraiser IS 'Property Appraiser master data.';

---x-- Tables related to Appraisal Management Company (AMC) - END  --x---


---x-- Tables related to Survey Company  - START  --x---
 CREATE TABLE mpa.survey_company (
  srvy_co_id SERIAL PRIMARY KEY,
  company_name CHARACTER VARYING(60) NOT NULL UNIQUE,  -- Company Name (unique identifier)
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$'), -- Enforces US zip code format
  country VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  website VARCHAR(255),
  notes TEXT,
  
  -- fields added on 19th March
  -- triang_survey BOOLEAN,		-- (Removed in 21st March)Does this survey co provide Triangulation survey or not
  -- alter table mpa.survey_company drop column triang_survey;
  
  -- gps_survey BOOLEAN		    -- (Removed in 21st March) Does this survey co provide GPS based survey or not
  -- alter table mpa.survey_company drop column gps_survey;
  
  -- fields added on 21st March 
  triang_service BOOLEAN		-- Does this survey company provide Triangulation Survery service.
  -- Types of surveys supported by co is taken care in Junction table with survey_type
  -- alter table mpa.survey_company add column triang_service boolean;
);

COMMENT ON TABLE mpa.survey_company IS 'Survey companies master data.'

CREATE TABLE mpa.survey_service_area (
  service_area_id SERIAL PRIMARY KEY,
  srvy_co_id INTEGER REFERENCES mpa.survey_company(srvy_co_id) NOT NULL,  -- Foreign key to survey_company table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') -- Enforces US zip code format
  
);

COMMENT ON TABLE mpa.survey_service_area IS 'Areas in which services are provided by a Survey Company.'; 

CREATE TABLE mpa.survey_type (
  srvy_type_id SERIAL PRIMARY KEY,
  srvy_type_name VARCHAR(100) NOT NULL UNIQUE,  -- Descriptive name of the survey type
  description TEXT  -- Optional field for detailed description
);
COMMENT ON TABLE mpa.survey_type IS 'Survey type master data';

-- Junction table for Survey Company & Survey Type
CREATE TABLE mpa.survey_company_survey_type (
	srvy_co_id	INTEGER,
	srvy_type_id INTEGER,
	PRIMARY KEY (srvy_co_id, srvy_type_id), 
	FOREIGN KEY (srvy_co_id) REFERENCES mpa.survey_company(srvy_co_id), 
	FOREIGN KEY (srvy_type_id) REFERENCES mpa.survey_type(srvy_type_id)
);
COMMENT ON TABLE mpa.survey_company_survey_type IS 'Junction table for Survey Company & Survey Type';

CREATE TABLE mpa.surveyor (
  surveyor_id SERIAL PRIMARY KEY,
  surveyor_licence_id VARCHAR(10) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  license_number VARCHAR(50),  -- Optional field for surveyor license number
  email VARCHAR(100) UNIQUE,  -- Ensures unique email addresses
  phone VARCHAR(20),
  srvy_co_id INTEGER REFERENCES mpa.survey_company(srvy_co_id) NOT NULL,  -- Foreign key to survey_company table
  
  -- fields added on 19th March
  geodetic_control BOOLEAN,  -- Does this surveyor handle Geodetic Control survey
  historic_preservation BOOLEAN  -- Does this surveyor handle Historic Preservation survey
);
COMMENT ON TABLE mpa.surveyor IS 'Surveyor master data.';

---x-- Tables related to Survey Company - END  --x---




