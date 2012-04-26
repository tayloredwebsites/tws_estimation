-- 090_estimates.sql


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
    customer_name integer NULL,
    sales_rep_id integer NULL,
    job_type_id integer NOT NULL,
    state_id integer NOT NULL,
    prevailing_wage boolean DEFAULT false NOT NULL,
    notes character varying(4000) NULL,
    deactivated boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE estimates_seq;
ALTER TABLE ONLY estimates
    ALTER COLUMN id SET DEFAULT NEXTVAL('estimates_seq'),
    ADD CONSTRAINT estimates_pk_id PRIMARY KEY (id),
    ADD CONSTRAINT estimates_fk_sales_reps_id FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id),
    ADD CONSTRAINT estimates_fk_job_types_id FOREIGN KEY (job_type_id) REFERENCES job_types(id),
    ADD CONSTRAINT estimates_fk_states_id FOREIGN KEY (state_id) REFERENCES states(id);


