-- 060_estimates.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE estimates (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    customer_lookup_id integer NULL,
    sales_rep_lookup_id integer NULL,
    job_type_lookup_id integer NOT NULL,
    state_lookup_id integer NOT NULL,
    prevailing_wage boolean DEFAULT false NOT NULL,
    est_notes character varying(4000) NULL,
    deactivated boolean DEFAULT false NOT NULL
);
-- CREATE TABLE estimates (
--     est_id integer NOT NULL,
--     est_name character varying(50) DEFAULT ''::character varying NOT NULL,
--     est_bid_date timestamp without time zone NOT NULL,
--     est_cust_id integer NOT NULL,
--     est_salesp_id integer NOT NULL,
--     est_deliv_id integer NOT NULL,
--     est_bond character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_prevail_wage character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_tax_status_id integer NOT NULL,
--     est_state_id integer NOT NULL,
--     est_walk_thru character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_walk_thru_date timestamp without time zone NOT NULL,
--     est_forms character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_control_reviewed character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_total_tonage integer NOT NULL,
--     est_cfm integer NOT NULL,
--     est_building_sq_ft integer NOT NULL,
--     est_heating_btu integer NOT NULL,
--     est_job_type_id integer NOT NULL,
--     est_locked character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_created_date timestamp without time zone,
--     est_deleted character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_simple character(1) DEFAULT 'N'::bpchar NOT NULL,
--     est_notes character varying(4000) DEFAULT ''::character varying NOT NULL
-- );
-- 
-- 
-- ALTER TABLE public.estimates OWNER TO postgres;


-- ALTER TABLE public.estimates OWNER TO postgres;


-- don't load data - this is just test data anyway


ALTER TABLE ONLY estimates
    ADD CONSTRAINT estimates_pk_estimates PRIMARY KEY (est_id);
--	ADD CONSTRAINT fk_estimates_customers FOREIGN KEY (est_cust_id) REFERENCES customers(cust_id),
--	ADD CONSTRAINT fk_estimates_deliverymethods FOREIGN KEY (est_deliv_id) REFERENCES deliverymethods(deliv_id),
--	ADD CONSTRAINT fk_estimates_sales_reps FOREIGN KEY (est_salesp_id) REFERENCES sales_reps(salesp_id),
--	ADD CONSTRAINT fk_estimates_taxtypes FOREIGN KEY (est_tax_status_id) REFERENCES taxtypes(tax_type_id);


