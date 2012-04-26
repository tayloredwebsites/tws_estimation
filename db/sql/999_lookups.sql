-- 070_lookups.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE lookups (
    id integer NOT NULL,
    store character varying(255) DEFAULT ''::character NOT NULL,
    name character varying(255) DEFAULT ''::character NOT NULL,
    value text varying(4000) NULL,
    deactivated boolan DEFAULT false NOT NULL
);
-- CREATE TABLE customers (
--     cust_id integer NOT NULL,
--     cust_num character varying(25) DEFAULT ''::character varying NOT NULL,
--     cust_co_name character varying(50) DEFAULT ''::character varying NOT NULL,
--     cust_name character varying(50) DEFAULT ''::character varying NOT NULL,
--     cust_addr1 character varying(50) DEFAULT ''::character varying NOT NULL,
--     cust_addr2 character varying(50) DEFAULT ''::character varying NOT NULL,
--     cust_city character varying(50) DEFAULT ''::character varying NOT NULL,
--     cust_zip character(10) DEFAULT ''::bpchar NOT NULL,
--     cust_state_id integer NOT NULL,
--     cust_phone character varying(25) DEFAULT ''::character varying NOT NULL,
--     cust_fax character varying(25) DEFAULT ''::character varying NOT NULL,
--     cust_walk_thru character(1) DEFAULT 'N'::bpchar NOT NULL,
--     cust_bid_forms character(1) DEFAULT 'N'::bpchar NOT NULL,
--     cust_control_rev character(1) DEFAULT 'N'::bpchar NOT NULL,
--     cust_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
-- );
-- 
--
--ALTER TABLE public.customers OWNER TO postgres;

-- CREATE TABLE jobtypes (
--     job_type_id integer NOT NULL,
--     job_type_desc character varying(50) DEFAULT ''::character varying NOT NULL,
--     job_type_mat_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
--     job_type_lab_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
--     job_type_sub_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
--     job_type_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
-- );
-- 
-- 
-- ALTER TABLE public.jobtypes OWNER TO postgres;

-- CREATE TABLE taxtypes (
--     tax_type_id integer NOT NULL,
--     tax_type_sort_order integer NOT NULL,
--     tax_type_desc character varying(50) DEFAULT ''::character varying NOT NULL
-- );
-- 
-- 
-- ALTER TABLE public.taxtypes OWNER TO postgres;

-- ALTER TABLE public.salespeople OWNER TO postgres;


--ALTER TABLE public.defaults OWNER TO postgres;

INSERT INTO defaults (id, store, name, value) VALUES
(1, 'Customers', '',''),
(2, 'Sales Reps', '',''),
(3, 'Job Types', '',''),
(4, 'States', '','')

-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (1, '1', 'Moksa, Inc', 'DiPaola, Vince', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'Y');
-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (4, '4', 'Joe''s Beauty Parlor', 'Joe Barber', '', '', '', '11111     ', 1, '', '', 'N', 'N', 'N', ' ');
-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (5, '5', 'Joe''s Auto Parts', 'Joe Smith', '', '', '', '          ', 1, '', '', 'Y', 'Y', 'N', ' ');
-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (6, '6', 'Joe''s Sandwich Shop', 'Joe Cook', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', ' ');
-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (7, '7', 'Moksa', 'Dave', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'N');
-- INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (12, '10', 'testing 1 2 3', 'testing 3 4 5', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'N');
-- 

-- INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (1, 1, 0.000, 5, 'N');
-- INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (2, 2, 0.000, 5, 'N');
-- INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (4, 4, 0.000, 0, 'N');
-- INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (3, 3, 0.000, 0, 'N');






CREATE SEQUENCE defaults_seq;
ALTER TABLE defaults
    ALTER COLUMN id SET DEFAULT NEXTVAL('defaultsseq'),
    ADD CONSTRAINT defaults_ix_defaults_description UNIQUE(description),

-- ALTER TABLE ONLY customers
--     ADD CONSTRAINT customers_pk_customer PRIMARY KEY (cust_id);
--
-- ALTER TABLE ONLY jobtypes
--     ADD CONSTRAINT jobtypes_pk_jobtypes PRIMARY KEY (job_type_id);
-- 
-- ALTER TABLE ONLY sales_reps
--     ADD CONSTRAINT sales_reps_pk_sales_reps PRIMARY KEY (salesp_id);
--
-- ALTER TABLE ONLY states
--     ADD CONSTRAINT states_pk_states PRIMARY KEY (state_id);
-- 
-- ALTER TABLE ONLY taxtypes
--     ADD CONSTRAINT taxtypes_pk_taxtypes PRIMARY KEY (tax_type_id);
--
-- CREATE UNIQUE INDEX customers_ix_customers ON customers USING btree (cust_num);
-- 
-- CREATE UNIQUE INDEX customers_ix_customers_1 ON customers USING btree (cust_co_name);
--
-- CREATE UNIQUE INDEX states_ix_states ON states USING btree (state_code);
-- 
-- CREATE UNIQUE INDEX states_ix_states_1 ON states USING btree (state_desc);
-- 
-- CREATE UNIQUE INDEX taxtypes_ix_taxtypes ON taxtypes USING btree (tax_type_desc);
--
-- ALTER TABLE ONLY customers
--     ADD CONSTRAINT fk_customers_states FOREIGN KEY (cust_state_id) REFERENCES states(state_id);
--
-- ALTER TABLE ONLY sales_reps
--     ADD CONSTRAINT fk_sales_reps_users FOREIGN KEY (salesp_user_id) REFERENCES users(users_id);
--
--
--
