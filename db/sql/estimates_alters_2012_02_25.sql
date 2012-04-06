
ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pk_customer PRIMARY KEY (cust_id);

ALTER TABLE ONLY delivery_methods
    ADD CONSTRAINT delivery_methods_pk_delivery_methods PRIMARY KEY (deliv_id);

ALTER TABLE ONLY estimate_components
    ADD CONSTRAINT estimate_components_pk_estimate_components PRIMARY KEY (est_comp_id);

ALTER TABLE ONLY estimates
    ADD CONSTRAINT estimates_pk_estimates PRIMARY KEY (est_id);

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pk_jobs PRIMARY KEY (job_id);

ALTER TABLE ONLY jobtypes
    ADD CONSTRAINT jobtypes_pk_jobtypes PRIMARY KEY (job_type_id);

ALTER TABLE ONLY sales_reps
    ADD CONSTRAINT sales_reps_pk_sales_reps PRIMARY KEY (salesp_id);

ALTER TABLE ONLY staterates
    ADD CONSTRAINT staterates_pk_staterates PRIMARY KEY (state_rate_id);

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pk_states PRIMARY KEY (state_id);

ALTER TABLE ONLY systemcomponents
    ADD CONSTRAINT systemcomponents_pk_systemcomponents PRIMARY KEY (sys_comp_id);

ALTER TABLE ONLY taxtypes
    ADD CONSTRAINT taxtypes_pk_taxtypes PRIMARY KEY (tax_type_id);

ALTER TABLE ONLY terms
    ADD CONSTRAINT terms_pk_terms PRIMARY KEY (terms_id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pk_users PRIMARY KEY (users_id);

ALTER TABLE ONLY vendorcomponents
    ADD CONSTRAINT vendorcomponents_pk_vendorsystems PRIMARY KEY (vend_comp_id);

ALTER TABLE ONLY vendors
    ADD CONSTRAINT vendors_pk_vendors PRIMARY KEY (vend_id);

ALTER TABLE ONLY vendorsystems
    ADD CONSTRAINT vendorsystems_pk_vendorsystems_1 PRIMARY KEY (vs_id);

CREATE UNIQUE INDEX customers_ix_customers ON customers USING btree (cust_num);

CREATE UNIQUE INDEX customers_ix_customers_1 ON customers USING btree (cust_co_name);

CREATE UNIQUE INDEX deliverymethods_ix_deliverymethods ON deliverymethods USING btree (deliv_desc);

CREATE UNIQUE INDEX jobs_ix_jobs ON jobs USING btree (job_name);

CREATE UNIQUE INDEX states_ix_states ON states USING btree (state_code);

CREATE UNIQUE INDEX states_ix_states_1 ON states USING btree (state_desc);

CREATE UNIQUE INDEX taxtypes_ix_taxtypes ON taxtypes USING btree (tax_type_desc);

CREATE UNIQUE INDEX terms_ix_terms ON terms USING btree (terms_desc);

CREATE UNIQUE INDEX users_ix_users ON users USING btree (users_name);

CREATE UNIQUE INDEX vendors_ix_vendors ON vendors USING btree (vend_num);

CREATE UNIQUE INDEX vendors_ix_vendors_1 ON vendors USING btree (vend_name);

ALTER TABLE ONLY customers
    ADD CONSTRAINT fk_customers_states FOREIGN KEY (cust_state_id) REFERENCES states(state_id);

ALTER TABLE ONLY estimatecomponents
    ADD CONSTRAINT fk_estimatecomponents_estimates FOREIGN KEY (est_comp_est_id) REFERENCES estimates(est_id);

ALTER TABLE ONLY estimatecomponents
    ADD CONSTRAINT fk_estimatecomponents_systemcomponents FOREIGN KEY (est_comp_sys_comp_id) REFERENCES systemcomponents(sys_comp_id);

ALTER TABLE ONLY estimatecomponents
    ADD CONSTRAINT fk_estimatecomponents_vendors FOREIGN KEY (est_comp_vend_id) REFERENCES vendors(vend_id);

ALTER TABLE ONLY estimates
    ADD CONSTRAINT fk_estimates_customers FOREIGN KEY (est_cust_id) REFERENCES customers(cust_id);

ALTER TABLE ONLY estimates
    ADD CONSTRAINT fk_estimates_deliverymethods FOREIGN KEY (est_deliv_id) REFERENCES deliverymethods(deliv_id);

ALTER TABLE ONLY estimates
    ADD CONSTRAINT fk_estimates_sales_reps FOREIGN KEY (est_salesp_id) REFERENCES sales_reps(salesp_id);

ALTER TABLE ONLY estimates
    ADD CONSTRAINT fk_estimates_taxtypes FOREIGN KEY (est_tax_status_id) REFERENCES taxtypes(tax_type_id);

ALTER TABLE ONLY estimatesystems
    ADD CONSTRAINT fk_estimatesystems_estimates FOREIGN KEY (est_sys_est_id) REFERENCES estimates(est_id);

ALTER TABLE ONLY estimatesystems
    ADD CONSTRAINT fk_estimatesystems_systems FOREIGN KEY (est_sys_sys_id) REFERENCES systems(sys_id);

ALTER TABLE ONLY jobcomponents
    ADD CONSTRAINT fk_jobcomponents_jobs FOREIGN KEY (job_comp_job_id) REFERENCES jobs(job_id);

ALTER TABLE ONLY jobcomponents
    ADD CONSTRAINT fk_jobcomponents_systemcomponents FOREIGN KEY (job_comp_sys_comp_id) REFERENCES systemcomponents(sys_comp_id);

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_jobs_customers FOREIGN KEY (job_cust_id) REFERENCES customers(cust_id);

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_jobs_deliverymethods FOREIGN KEY (job_deliv_id) REFERENCES deliverymethods(deliv_id);

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_jobs_sales_reps FOREIGN KEY (job_salesp_id) REFERENCES sales_reps(salesp_id);

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_jobs_taxtypes FOREIGN KEY (job_tax_status_id) REFERENCES taxtypes(tax_type_id);

ALTER TABLE ONLY sales_reps
    ADD CONSTRAINT fk_sales_reps_users FOREIGN KEY (salesp_user_id) REFERENCES users(users_id);

ALTER TABLE ONLY staterates
    ADD CONSTRAINT fk_staterates_componenttypes FOREIGN KEY (state_rate_comp_type_id) REFERENCES componenttypes(comp_type_id);

ALTER TABLE ONLY staterates
    ADD CONSTRAINT fk_staterates_states FOREIGN KEY (state_rate_state_id) REFERENCES states(state_id);

ALTER TABLE ONLY staterates
    ADD CONSTRAINT fk_staterates_taxtypes FOREIGN KEY (state_rate_tax_type_id) REFERENCES taxtypes(tax_type_id);

ALTER TABLE ONLY systemcomponents
    ADD CONSTRAINT fk_systemcomponents_components FOREIGN KEY (sys_comp_comp_id) REFERENCES components(comp_id);

ALTER TABLE ONLY systemcomponents
    ADD CONSTRAINT fk_systemcomponents_systems FOREIGN KEY (sys_comp_sys_id) REFERENCES systems(sys_id);

ALTER TABLE ONLY vendorcomponents
    ADD CONSTRAINT fk_vendorcomponents_systemcomponents1 FOREIGN KEY (vend_comp_sys_comp_id) REFERENCES systemcomponents(sys_comp_id);

ALTER TABLE ONLY vendors
    ADD CONSTRAINT fk_vendors_states1 FOREIGN KEY (vend_state_id) REFERENCES states(state_id);

ALTER TABLE ONLY vendors
    ADD CONSTRAINT fk_vendors_terms FOREIGN KEY (vend_terms_id) REFERENCES terms(terms_id);

ALTER TABLE ONLY vendorsystems
    ADD CONSTRAINT fk_vendorsystems_systems FOREIGN KEY (vs_sys_id) REFERENCES systems(sys_id);

ALTER TABLE ONLY vendorsystems
    ADD CONSTRAINT fk_vendorsystems_vendors FOREIGN KEY (vs_vend_id) REFERENCES vendors(vend_id);

ALTER TABLE ONLY vendorcomponents
    ADD CONSTRAINT fk_vendorsystems_vendors1 FOREIGN KEY (vend_comp_vend_id) REFERENCES vendors(vend_id);

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
