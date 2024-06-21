CREATE TABLE mpa.prop_rstr_catg 
(
    catg_id SERIAL PRIMARY KEY, -- Restriction Category ID
    catg_type CHARACTER VARYING(35) UNIQUE NOT NULL,
    catg_desc CHARACTER VARYING(300) NOT NULL,
    created_by INTEGER NOT NULL, -- User ID of user who created
    created_on DATE NOT NULL, -- Date when the record was created
    updated_by INTEGER, -- User ID of the last updater
    updated_on DATE  -- Date when the record was last updated
);

COMMENT ON TABLE mpa.prop_rstr_catg IS 'Property rstriction Catogeries';
----------------

-- Between prop_rstr_catg & prop_rstr there exists 1-to-M relation

CREATE TABLE mpa.prop_rstr
(
	rstr_id SERIAL PRIMARY KEY, --restriction ID
	rstr_catg_id INTEGER NOT NULL,
	rstr_type CHARACTER VARYING(30) UNIQUE NOT NULL,
	rstr_desc CHARACTER VARYING(300) NOT NULL,
	status CHAR(1) CHECK (status IN ('I', 'A')), -- Accepts only 'I' -- InActive and 'A' -- Active
	created_by INTEGER NOT NULL, -- User ID of user who created
        created_on DATE  NOT NULL, -- Date when the record was created
        updated_by INTEGER, -- User ID of the last updater
        updated_on DATE, -- Date when the record was last updated
	CONSTRAINT "FK_PROP_rstr_CATEGORY" FOREIGN KEY (rstr_catg_id)
        REFERENCES mpa.prop_rstr_catg (catg_id)
);

COMMENT ON TABLE mpa.prop_rstr IS 'Property rstrictions for Mortgage';

----------------

CREATE SEQUENCE mpa.loan_prod_seq START 10001;

CREATE TABLE mpa.loan_prod
(
	prod_id INTEGER DEFAULT NEXTVAL('mpa.loan_prod_seq') PRIMARY KEY,
	prod_name CHARACTER VARYING(50) NOT NULL UNIQUE,
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
        lockin_period INTEGER NOT NULL, 	-- min period in months for which loan must be serviced.  Borrower can initiate pre-payment only after the lockin period if desired
	docu_reqrm CHARACTER VARYING(500) NOT NULL,  -- Documentation requirements - free text
	escrow_req BOOLEAN NOT NULL,				-- Is Escrow required for the loan product
  	prop_rstr_exists BOOLEAN NOT NULL,			-- Do Property restrictions exist for the loan product
	status BOOLEAN NOT NULL,  				-- If true the loan product is currently Active else Inactive
	created_by INTEGER NOT NULL, -- User ID of user who created
        created_on DATE NOT NULL, -- Date when the record was created
        updated_by INTEGER, -- User ID of the last updater
        updated_on DATE -- Date when the record was last updated
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
	created_by INTEGER NOT NULL, -- User ID of user who created
	updated_by INTEGER, -- User ID of the last updater
	CONSTRAINT "ST_DATE_CHK" CHECK (end_dt >= start_dt)
);

COMMENT ON TABLE mpa.loan_prod_status_history IS 'Timelines for loan product being Active or Inactive';

/*
NOTE: mpa.loan_prod_status_history - In the application layer it should be taken care that for a given prod_id start_dt cannot be on or before any of the same prod_id's already existing end_dt.  This is necessary to avoid overlaping active/inactive periods for any product.

If start_dt & end_dt are same in an entry => the loan product was active for just one day
*/

--mpa.pre_pay_penalty_master table script added on 22nd March

CREATE TABLE mpa.pre_pay_penalty_master
( 
	prod_id INTEGER  Primary Key,  -- UNIQUE because of 1-to-1 relation with loan_prod table
	min_penalty_amt DECIMAL(18,2) NOT NULL,
	penalty_percentage DECIMAL(5,2) NOT NULL, -- value should be between 0 and 100
        created_by INTEGER NOT NULL, -- User ID of user who created
        created_on DATE  NOT NULL, -- Date when the record was created
        updated_by INTEGER, -- User ID of the last updater
        updated_on DATE, -- Date when the record was last updated
	CONSTRAINT "PROD_ID_penm" FOREIGN KEY (prod_id)
        REFERENCES mpa.loan_prod(prod_id)
	
);

COMMENT ON TABLE mpa.pre_pay_penalty_master IS 'Master data related to pre-pay penalty of loan product';
