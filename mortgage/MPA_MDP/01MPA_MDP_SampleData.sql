-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- Property restriction Categories
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
INSERT INTO mpa.prop_rstr_catg (catg_type, catg_desc)
	VALUES (
		'Property Type', 
		'Depending upon the Loan Product there could be restrictions to accept a property for mortgage depending on Property Type'
		   );
		   
INSERT INTO mpa.prop_rstr_catg (catg_type, catg_desc)
	VALUES (
		'Occupancy Type', 
		'Depending upon the Loan Product there could be restrictions to accept a property for mortgage depending on Occupancy Type'
		   );		   
		   
INSERT INTO mpa.prop_rstr_catg (catg_type, catg_desc)
	VALUES (
		'Property Title', 
		'Insuffcient property title is a restriction for mortgaging'
		   );		   
 
INSERT INTO mpa.prop_rstr_catg (catg_type, catg_desc)
	VALUES (
		'Environment Approval', 
		'Lack of approvals from the State in environmental sensitive zones will restrict mortgage loan clearances'
		   );		   
		   
INSERT INTO mpa.prop_rstr_catg (catg_type, catg_desc)
	VALUES (
		'Property Condition', 
		'Non-habital or unsafe condition of properts might impose restrictions for mortgage loan clearances'
		   );		   
		   
--------------------------------------------

-- rstr_catg_id = 1 => Property Type
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		1, 
		'Multi-Unit',
		'Multi-unit residential properties like Duplex, Triplex, Four Plex etc are restricted for mortgaging'
		   );		   

INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		1, 
		'HOA',
		'Properties requiring approval of House Owner Association (HOA) are restricted'
		   );

INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		1, 
		'Townhouses',
		'Limited or no demand for Townhouses hampers sale of property in case of loan default'
		   );
		   
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		1, 
		'Condominium',
		'Condominium, or condo, properties are restricted due to partial ownership of the prospective borower'
		   );

-- rstr_catg_id = 3 => Property Title   
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		3, 
		'Pre-Existing Mortgage Loan',
		'Already mortgage exists on part of the property'
		   );

INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		3, 
		'Tax Leins',
		'Upaid property tax claims by the Government exist'
		   );
		   
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		3, 
		'Mechanic''s Leins',
		'Claim by contractors and/or sub-contractors for unpaid work on property'
		   );

INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		3, 
		'Judgement Leins',
		'Claims resulting from court judgement(s) against the property'
		   );		   	
		   
-- rstr_catg_id = 4 => Environment Approval
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		4, 
		'Flood Plains',
		'Property in zones declared as flood plains are restricted'
		   );

INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		4, 
		'Crititcal Habitat Area',
		'Property in zones declared as Crititcal Habitat Area for certain species of plants and/or animals are restricted'
		   );
		   
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		4, 
		'Ground Water Protection Area',
		'Property in zones declared as Ground Water Protection Area are restricted'
		   );
		   
INSERT INTO mpa.prop_rstr (rstr_catg_id, rstr_type, rstr_desc)
	VALUES (
		4, 
		'Wile Life Corridor',
		'Property in zones declared as Wile Life Corridor are restricted'
		   );		 		   
--------------------------------------------
-- Data for Loan Products and its m-2-m relation with Property Restrictions for loan

INSERT INTO mpa.loan_prod
 (prod_name, intr_rate, loan_term, max_loan_amt, mdp, mdp_type, min_cr_score, max_ltv_ratio, pmi_req, orgin_fee, prepay_penalty, docu_reqrm, escrow_req, prop_rstr_exists, status)
 VALUES
 ('Conventional 30-Year Fixed', 3.25,  360, 500000, 5.0, 'PERCENTAGE', 620, 95.0, TRUE, 1000.00, FALSE, 'Income verification, tax returns', TRUE, TRUE, TRUE);
INSERT INTO mpa.loan_prod_prop_rstr (prod_id, rstr_id) VALUES (10001, 1), (10001, 4), (10001, 6), (10001, 7), (10001, 11);	

	
INSERT INTO mpa.loan_prod
 (prod_name, intr_rate, loan_term, max_loan_amt, mdp, mdp_type, min_cr_score, max_ltv_ratio, pmi_req, orgin_fee, prepay_penalty, docu_reqrm, escrow_req, prop_rstr_exists, status)
 VALUES
 ('FHA 30-Year Fixed', 3.75,  360, 350000, 3450.0, 'ABSOLUTE', 580, 97.0, TRUE, 2000.00, TRUE, 'Income verification, tax returns, proof of residency', TRUE, TRUE, TRUE);   
INSERT INTO mpa.loan_prod_prop_rstr (prod_id, rstr_id) VALUES (10002, 3), (10002, 4), (10002, 10), (10002, 12);


INSERT INTO mpa.loan_prod
 (prod_name, intr_rate, loan_term, max_loan_amt, mdp, mdp_type, min_cr_score, max_ltv_ratio, pmi_req, orgin_fee, prepay_penalty, docu_reqrm, escrow_req, prop_rstr_exists, status)
 VALUES
 ('VA 30-Year Fixed', 3.00,  360, 700000, 0.0, 'ABSOLUTE', 620, 100, FALSE, 1500.00, FALSE, 'Proof of military service, income verification', TRUE, TRUE, TRUE);
INSERT INTO mpa.loan_prod_prop_rstr (prod_id, rstr_id) VALUES (10003, 5), (10003, 6); 
 

/*
-- ToDo for mpa.loan_prod & mpa.loan_prod_prop_rstr
	(prod_name, intr_rate, loan_term, max_loan_amt, min_cr_score, max_ltv_ratio, pmi_req, orgin_fee, prepay_penalty, docu_reqrm, escrow_req) - some fields are missing, make up your own data for them.
	
    ('Conventional 15-Year Fixed', 2.75, 180, 400000, 700, 90.0, 'Single-Family', 80.0, FALSE, 1200.00, TRUE, 'Income verification, tax returns', TRUE),
	
    ('FHA 15-Year Fixed', 3.25, 180, 300000, 620, 3.5, 'Single-Family', 90.0, TRUE, 2500.00, TRUE, 'Income verification, tax returns, proof of residency', TRUE),
	
    ('VA 15-Year Fixed', 2.50, 180, 600000, 640, 0.0, 'Single-Family', 100.0, FALSE, 1000.00, FALSE, 'Proof of military service, income verification', TRUE),
	
    ('USDA 30-Year Fixed', 3.00, 360, 250000, 640, 0.0, 'Single-Family', 100.0, TRUE, 1500.00, FALSE, 'Income verification, property eligibility', TRUE),
	
    ('Jumbo 30-Year Fixed', 3.50, 360, 1000000, 720, 20.0, 'Single-Family', 80.0, FALSE, 3000.00, FALSE, 'Income verification, tax returns, asset verification', TRUE),
	
    ('Adjustable-Rate Mortgage (ARM)', 3.50, 360, 500000, 680, 5.0, 'Single-Family', 95.0, TRUE, 2000.00, TRUE, 'Income verification, tax returns, proof of residency', TRUE),
	
    ('Home Equity Loan', 4.25, 180, 200000, 640, 20.0, 'Single-Family', 80.0, FALSE, 1500.00, FALSE, 'Income verification, property appraisal', FALSE),
	
    ('Reverse Mortgage', 4.75, 360, 500000, 620, 0.0, 'Single-Family', 60.0, TRUE, 5000.00, FALSE, 'Age verification, property appraisal, counseling certificate', TRUE),
	
    ('Interest-Only Mortgage', 4.00, 360, 750000, 700, 20.0, 'Single-Family', 80.0, TRUE, 2500.00, FALSE, 'Income verification, asset verification', TRUE),

    ('Graduated Payment Mortgage', 4.25, 360, 500000, 660, 5.0, 'Single-Family', 95.0, TRUE, 2500.00, TRUE, 'Income verification, tax returns', TRUE),
	
	('Graduated Payment ARM', 4.00, 360, 500000, 700, 5.0, 'Single-Family', 95.0, TRUE, 2000.00, TRUE, 'Income verification, tax returns', TRUE),
	
    ('Balloon Mortgage', 5.75, 180, 300000, 680, 10.0, 'Single-Family', 80.0, FALSE, 3000.00, TRUE, 'Income verification, property appraisal', TRUE),
	
    ('Interest-Only ARM', 4.50, 360, 750000, 720, 20.0, 'Single-Family', 80.0, TRUE, 3500.00, TRUE, 'Income verification, asset verification', TRUE),
	
    ('Conventional 20-Year Fixed', 3.00, 240, 450000, 700, 15.0, 'Single-Family', 85.0, TRUE, 1500.00, FALSE, 'Income verification, tax returns', TRUE),

*/

INSERT INTO mpa.loan_prod_status_history (prod_id, start_dt, end_dt)
	VALUES(10001, '2003-03-01', '9999-12-31'),
	      (10002, '2003-04-15', '2021-12-31'),
		  (10004, '2005-10-15', '9999-12-31'),
		  (10002, '2022-07-01', '9999-12-31');
		  
-------------------Escrow START -------------------------
INSERT INTO mpa.escrow_companies (esco_name, address, city, state, zipcode, phone, email,in_escrow_ac_no, es_ac_bank_name, es_process_time) VALUES
('Alpha Escrow Services', '123 Main St', 'Los Angeles', 'California', '90001', '555-123-4567', 'info@abcescrow.com','438723389873','Bank of Weston',30),
('X-Celente Escrow Solutions', '456 Oak Ave', 'New York', 'New York', '10001', '555-987-6543', 'contact@xyzescrow.com','438672368312', 'Mabrey Bank', 28),
('Best Escrow Co.', '789 Elm St', 'Chicago', 'Illinois', '60601', '555-456-7890', 'hello@bestescrowco.com','578445879648','Bank of America', 30),
('Sunshine Escrow LLC', '321 Maple St', 'Miami', 'Florida', '33101', '555-789-0123', 'info@sunshineescrowllc.com','3454897232392','Bank of Weston',30),
('Top Tier Escrow', '555 Pine St', 'San Francisco', 'California', '94101', '555-234-5678', 'contact@toptierescrow.com','785930925438','Bank of Weston',26),
('Secure Escrow Inc.', '777 Cedar St', 'Seattle', 'Washington', '98101', '555-345-6789', 'support@secureescrowinc.com','748939805490','Bank of Weston',30),
('Premier Escrow Group', '888 Walnut St', 'Dallas', 'Texas', '75201', '555-567-8901', 'info@premierescrowgroup.com','239843983478','Mabrey Bank', 30),
('Golden State Escrow', '999 Birch St', 'San Diego', 'California', '92101', '555-678-9012', 'contact@goldenstateescrow.com','327849243879','Mabrey Bank', 30),
('Liberty Escrow Services', '111 Ash St', 'Boston', 'Massachusetts', '02101', '555-890-1234', 'info@libertyescrow.com','324879234987','Bank of America', 30),
('Elite Escrow Solutions', '222 Elm St', 'Houston', 'Texas', '77001', '555-901-2345', 'hello@eliteescrowsolutions.com','878232879131','Mabrey Bank', 30);

INSERT INTO mpa.escrow_requirements (req_name, description)
VALUES
    ('Property Taxes', 'Escrow account must cover property taxes.'),
    ('Homeowners Insurance', 'Escrow account must cover homeowners insurance premiums.'),
    ('Mortgage Insurance', 'Escrow account must cover private mortgage insurance premiums (if applicable).'),
    ('Flood Insurance', 'Escrow account must cover flood insurance premiums (if applicable).'),
    ('HMO Assessments', 'Escrow account may cover assessments or fees for as home owners association dues.');


INSERT INTO mpa.escrow_requirements_loan_prod (prod_id, req_id)
VALUES
    (10001, 1), 
    (10001, 2), 
    (10002, 1), 
    (10002, 2), 
    (10002, 4), 
    (10003, 1), 
    (10003, 5);

INSERT INTO mpa.escrow_service_area (esco_id, county, city, state, zipcode) 
	VALUES (2, 'Los Angeles', 'Los Angeles', 'California', '90001'),
	       (2, 'Orange', 'Anaheim', 'California', '92801'),
	       (3, 'San Francisco', 'San Francisco', 'California', '94102'),
	       (2, 'King', 'Seattle', 'Washington', '98101'),
	       (2, 'Multnomah', 'Portland', 'Oregon', '97201'),
	       (3, 'Multnomah', 'Portland', 'Oregon', '97201');
-------------------Escrow END -------------------------

-------------------Underwriting START -------------------------

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

INSERT INTO mpa.underwriting_criteria_loan_prod (prod_id, criteria_id)
VALUES
    (10001, 1), 
    (10001, 4), 
    (10002, 3), 
    (10002, 5), 
    (10002, 9), 
    (10003, 1), 
    (10003, 3);

INSERT INTO mpa.underwriting_service_area (uwco_id, county, city, state, zipcode) 
VALUES 
    (1, 'Monroe County', 'Rochester', 'NY', '10001'),
    (1, 'Kings County', 'Albany', 'NY', '10002'),
    (2, 'Essex County', 'Newark', 'NJ', '07001'),
    (3, 'Miami-Dade Count', 'Miami', 'FL', '33001');
	
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

INSERT INTO mpa.underwriter (appraiser_licence_id, first_name, last_name, license_number, email, phone, uwco_id, liability_insu) 
VALUES 
    ('A123456', 'Carl', 'Sagan', 'UW123', 'carl.sagan@example.com', '555-123-4567', 1, 'Comprehensive liability coverage to protect against potential risks, ensuring financial security and peace of mind.'),
    ('B789012', 'Philip', 'Khotler', 'UW456', 'philip.khotler@example.com', '555-987-6543', 2, 'Robust liability insurance shields assets from legal liabilities, offering financial protection and risk mitigation.'),
    ('C345678', 'Michael', 'Doe', NULL, 'michael.doe@example.com', '555-555-5555', 3, 'Reliable liability coverage safeguards against unforeseen events, providing financial security and legal defense assistance.');

------------------- Underwriting END -------------------------

------------------- Appraisal Company START -------------------------

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


-- Appraisal Property type sample data
INSERT INTO mpa.appraisal_property_types (prop_type_name) 
VALUES
    ('Single Family Residence'),
    ('Condominium'),
    ('Townhouse'),
    ('Multi-Family Residence'),
    ('Vacant Land'),
    ('Commercial Property'),
    ('Industrial Property');

INSERT INTO mpa.appraisal_company_property_type(amc_id, prop_type_id)
VALUES
	(1,3),
	(1,5),
	(2,4),
	(4,1),
	(4,2),
	(4,6);
	
INSERT INTO mpa.appraisal_service_area (amc_id, county, city, state, zipcode) 
VALUES 
  (1, 'Los Angeles County', 'Los Angeles', 'California', '90001'),
  (1, 'San Francisco County', 'San Francisco', 'California', '94102'),
  (2, 'Cook County', 'Chicago', 'Illinois', '60601'),
  (2, 'Kings County', 'Brooklyn', 'New York', '11201'),
  (3, 'Harris County', 'Houston', 'Texas', '77001'),
  (4, 'Miami-Dade County', 'Miami', 'Florida', '33101'),
  (4, 'Dallas County', 'Dallas', 'Texas', '75201'),
  (5, 'King County', 'Seattle', 'Washington', '98101');	
  
INSERT INTO mpa.property_appraiser (appraiser_licence_id, first_name, last_name, license_number, email, phone, amc_id, expert_witness_testimony) 
VALUES 
  ('APL001', 'John', 'Doe', 'LIC001', 'john.doe@example.com', '+1234567890', 1, true),
  ('APL002', 'Jane', 'Smith', 'LIC002', 'jane.smith@example.com', '+1987654321', 2, false),
  ('APL003', 'Michael', 'Johnson', NULL, 'michael.johnson@example.com', '+1122334455', 1, true),
  ('APL004', 'Emily', 'Davis', 'LIC003', 'emily.davis@example.com', '+1555666777', 3, false),
  ('APL005', 'Christopher', 'Brown', NULL, 'chris.brown@example.com', '+1888999000', 2, true),
  ('APL006', 'Jessica', 'Wilson', 'LIC004', 'jessica.wilson@example.com', '+1777888999', 1, false),
  ('APL007', 'David', 'Martinez', NULL, 'david.martinez@example.com', '+1666777888', 3, true),
  ('APL008', 'Sarah', 'Anderson', 'LIC005', 'sarah.anderson@example.com', '+1999888777', 2, false);  
------------------- Appraisal Company END -------------------------


------------------- Survey Company START -------------------------
INSERT INTO mpa.survey_company (company_name, address, city, state, zipcode, country, phone, email, website, notes, triang_service) 
VALUES 
    ('ABC Surveyors', '123 Main St', 'Anytown', 'CA', '90210', 'USA', '555-123-4567', 'info@abcsurveyors.com', 'www.abcsurveyors.com', 'Reliable survey firm with extensive experience, ensuring accurate property assessments for mortgage approval.', TRUE),
    ('XYZ Land Surveying', '456 Elm St', 'Otherville', 'NY', '10001', 'USA', '555-987-6543', 'info@xyzlandsurveying.com', 'www.xyzlandsurveying.com', 'Efficient surveying services expedite mortgage processes, providing precise data and reliable documentation for lenders.', TRUE),
    ('LMN Geomatics', '789 Oak St', 'Anycity', 'TX', '75001', 'USA', '555-321-0987', 'info@lmngeomatics.com', 'www.lmngeomatics.com', 'Trusted survey company offers thorough inspections, facilitating smooth mortgage transactions with detailed property evaluations.', FALSE);
	
INSERT INTO mpa.survey_service_area (srvy_co_id, county, city, state, zipcode) 
VALUES 
  (1, 'Los Angeles County', 'Los Angeles', 'California', '90001'),
  (1, 'San Francisco County', 'San Francisco', 'California', '94102'),
  (3, 'Cook County', 'Chicago', 'Illinois', '60601'),
  (1, 'Kings County', 'Brooklyn', 'New York', '11201'),
  (2, 'Harris County', 'Houston', 'Texas', '77001'),
  (2, 'Miami-Dade County', 'Miami', 'Florida', '33101'),
  (2, 'Dallas County', 'Dallas', 'Texas', '75201'),
  (2, 'King County', 'Seattle', 'Washington', '98101');	

INSERT INTO mpa.survey_type (srvy_type_name, description)
VALUES 
	('Boundary Survey', 'Determines the legal boundaries of a property.'),
	('ALTA Survey', 'American Land Title Association survey, used for various real estate transactions.'),
    ('Elevation Certificate', 'Measures the elevation of a property relative to a flood hazard zone.'),
	('FEMA Elevation Certificate', 'Federal Emergency Management Agency (FEMA) - used in floodplain mapping and flood risk analysis'),
	('Site Improvement Survey', 'Surveys existing improvements on a property.'),
	('Triangulation survey', 'Method using triangles to measure distances, angles, and locations accurately for mapping'),
	('GPS survey', 'Utilizes satellite technology for precise property mapping, aiding mortgage approval through accurate location data.');
	
-- Generate sample data for mpa.survey_company_survey_type & mpa.surveyor tables
------------------- Survey Company END -------------------------