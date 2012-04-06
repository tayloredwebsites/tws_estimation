-- 040_assemblies.sql

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

--DROP TABLE assemblies;

CREATE TABLE assemblies (
    id integer NOT NULL,
	description character varying(255) DEFAULT ''::character varying NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    required boolean DEFAULT false NOT NULL,
    deactivated boolean DEFAULT false NOT NULL
);
-- ALTER TABLE public.assemblies OWNER TO RoR;


INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (1, 90, 'Rooftop', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (2, 100, 'Split Systems', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (3, 110, 'VAV System', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (4, 60, 'Exhaust Fans/Ventilation', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (5, 30, 'Controls', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (6, 70, 'Furnace/Duct Furnace Unit Heater', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (7, 0, 'Make-up Air', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (8, 50, 'Ductless Split System', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (9, 20, 'Chiller', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (10, 40, 'Cooling Tower', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (11, 10, 'Boiler', false, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (12, 9999, 'Estimate Total', true, false);
INSERT INTO assemblies (id, sort_order, description, required, deactivated) VALUES (13, 9998, 'Simplified', false, false);

-- DROP SEQUENCE assemblies_seq;
CREATE SEQUENCE assemblies_seq;
ALTER TABLE ONLY assemblies
	ALTER COLUMN id SET DEFAULT NEXTVAL('assemblies_seq'),
    ADD CONSTRAINT assemblies_pk_assemblies PRIMARY KEY (id),
    ADD CONSTRAINT assemblies_ix_description UNIQUE(description)


