CREATE SCHEMA AMS;

COMMENT ON SCHEMA ams
    IS 'Appraisal Management System Schema';
-------------------------------------------------
-- For now insert user data from backend
CREATE TABLE ams."users"
(
    user_id serial NOT NULL,
	user_name character varying(60) NOT NULL,
    password text NOT NULL,
    enabled boolean,
	first_name character varying(60) NOT NULL,
	last_name character varying(60) NOT NULL,
	created_on date,
    created_by character varying(60),
	updated_on date,
	updated_by character varying(60),
	pwd_reset boolean,
    PRIMARY KEY (user_id),
    CONSTRAINT "user_name_UNIQUE" UNIQUE (user_name)
);

COMMENT ON TABLE ams."users"
    IS 'User Master for Appraisal Management System application';
----------------------------------------
CREATE TABLE ams."amc"
(
    amc_id serial,
	amc_reg_id character varying(10) NOT NULL,
	amc_name character varying(60) NOT NULL,
	amc_remarks character varying(1000),
	website character varying(100),
	addr_line1 character varying(100),
	addr_line2 character varying(100),
	state character varying(2),
	city character varying(25),
	zip_code character varying(6),
    created_on date,
	created_by integer NOT NULL,
	updated_on date,
	updated_by integer NOT NULL,
	active character(1),
    
	PRIMARY KEY (amc_id),
    CONSTRAINT "amc_name_UNIQUE" UNIQUE (amc_name),
	CONSTRAINT "zip_code_regex" CHECK ( zip_code SIMILAR TO '[0-9]{6}' ),	
	CONSTRAINT "created_by_FK" FOREIGN KEY (created_by) REFERENCES ams.users (user_id),
	CONSTRAINT "updated_by_FK" FOREIGN KEY (updated_by) REFERENCES ams.users (user_id)
);

COMMENT ON SCHEMA amc
    IS 'Appraisal Management Company - Master Data';
	
ALTER TABLE ams.amc ADD CONSTRAINT "active_yes_no" CHECK (active = 'Y' OR active = 'N');	
----------------------------------------	
CREATE TABLE ams.appraisal_loc
(
	loc_id serial,
	state character varying(2),
	city character varying(25),
	CONSTRAINT "appraisal_loc_id_PK" PRIMARY KEY (loc_id),
	CONSTRAINT "appraisal_loc_state_city_UNIQUE" UNIQUE (state, city)
);

COMMENT ON TABLE ams.appraisal_loc
    IS 'Location data for property appraisals - Master Data';
----------------------------------------
CREATE TABLE ams.amc_appraisal_loc
(
	amc_id integer,
	loc_id integer,
	CONSTRAINT "amc_id_loc_id_PK" PRIMARY KEY (amc_id, loc_id),
	CONSTRAINT "amc_appraisal_loc_FK" FOREIGN KEY (amc_id) REFERENCES ams.amc (amc_id),
	CONSTRAINT "loc_appraisal_loc_FK" FOREIGN KEY (loc_id) REFERENCES ams.appraisal_loc (loc_id)
);

COMMENT ON TABLE ams.amc_appraisal_loc
    IS 'Join Table for amc and appriasal_loc tables';
----------------------------------------
-- For now insert property_type data from backend
CREATE TABLE ams.property_type
(
	type_id serial,
	type_desc character varying(35) NOT NULL,
	CONSTRAINT "property_type_PK" PRIMARY KEY (type_id)
);

COMMENT ON TABLE ams.property_type
	IS 'Type of Property being appraised';
----------------------------------------	
CREATE TABLE ams.amc_project
(
	proj_id serial,
	amc_id integer NOT NULL,
	prop_type_id integer NOT NULL,
	proj_client character varying(35) NOT NULL,
	proj_remarks character varying(1000),
	client_remarks character varying(1000),
	proj_start_dt date NOT NULL,
	proj_end_dt date,
	estimate_value decimal(9,2) NOT NULL,
	loc_id integer NOT NULL,
	CONSTRAINT "amc_project_PK" PRIMARY KEY (proj_id),
	CONSTRAINT "amc_project_amc_FK" FOREIGN KEY (amc_id) REFERENCES ams.amc (amc_id),
	CONSTRAINT "amc_project_prop_typ_FK" FOREIGN KEY (prop_type_id) REFERENCES ams.property_type (type_id),
	CONSTRAINT "amc_project_loc_FK" FOREIGN KEY (loc_id) REFERENCES ams.appraisal_loc (loc_id)
);

COMMENT ON TABLE ams.amc_project
    IS 'Historical data of AMC projects';