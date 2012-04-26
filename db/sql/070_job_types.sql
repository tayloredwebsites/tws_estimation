-- 070_job_types.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE job_types (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    deactivated boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE job_types_seq;
ALTER TABLE job_types
    ALTER COLUMN id SET DEFAULT NEXTVAL('job_types_seq'),
    ADD CONSTRAINT job_types_pk_id PRIMARY KEY (id),
    ADD CONSTRAINT job_types_ix_name UNIQUE(name);


INSERT INTO job_types (name, description, sort_order) VALUES
('Tax Exempt', 'Tax Exempt Work', 10),
('New Construction', 'New Construction Work', 20),
('Renovation', 'Renovation Work', 30),
('Residential', 'Residential Work', 40),
('Manufacturing', 'Manufacturing Work', 50);
