
-----------Escrow_Companies related tables-----------------

CREATE TABLE mpa.escrow_companies (
    esco_id SERIAL PRIMARY KEY,
    esco_name CHARACTER VARYING(60),
    address CHARACTER VARYING(255),
    city CHARACTER VARYING(100),
    state CHARACTER VARYING(100),
    zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$'),
    phone CHARACTER VARYING(20),
    email CHARACTER VARYING(60),
	in_escrow_ac_no CHARACTER VARYING(20),    
	es_ac_bank_name CHARACTER VARYING(20),   
	es_process_time INTEGER 

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
	FOREIGN KEY (req_id) REFERENCES mpa.escrow_requirements(req_id)
);
COMMENT ON TABLE mpa.escrow_requirements IS 'Junction table to set M-2-M relation between escrow requirements and loan products';

CREATE TABLE mpa.escrow_service_area (
  service_area_id SERIAL PRIMARY KEY,
  esco_id INTEGER REFERENCES mpa.escrow_companies(esco_id) NOT NULL,  -- Foreign key to escrow_companies table
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zipcode VARCHAR(5) CHECK (zipcode ~ '^([0-9]{5})?$') 
);

COMMENT ON TABLE mpa.escrow_service_area IS 'Service areas of an Escrow company';


CREATE TABLE mpa.escrow_agent (
  escrow_agent_id SERIAL PRIMARY KEY,
  escrow_licence_id VARCHAR(10) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE, 
  phone VARCHAR(20),
  esco_id INTEGER REFERENCES mpa.escrow_companies(esco_id) NOT NULL,  
  avg_tx_vol  INTEGER,
  tx_success_rate DECIMAL (5,2), 
  escrow_sw VARCHAR(50)   
);
COMMENT ON TABLE mpa.escrow_agent IS 'Escrow Agent master data.';