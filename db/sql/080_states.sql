-- 080_states.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE states (
    id integer NOT NULL,
    code character (2) NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    deactivated boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE states_seq;
ALTER TABLE states
    ALTER COLUMN id SET DEFAULT NEXTVAL('states_seq'),
    ADD CONSTRAINT states_pk_id PRIMARY KEY (id),
    ADD CONSTRAINT states_ix_code UNIQUE(code),
    ADD CONSTRAINT states_ix_name UNIQUE(name);

INSERT INTO states (code, name) VALUES
('CT', 'Connecticut   '),
('MA', 'Massachusetts'),
('NY', 'New York'),
('RI', 'Rhode Island');
