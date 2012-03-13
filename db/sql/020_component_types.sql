-- 020_component_types.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE component_types (
    id integer NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    has_costs boolean DEFAULT true NOT NULL,
    has_hours boolean DEFAULT false NOT NULL,
    has_vendor boolean DEFAULT false NOT NULL,
    has_misc boolean DEFAULT false NOT NULL,
    no_entry boolean DEFAULT false NOT NULL,
	created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deactivated boolean DEFAULT false NOT NULL
);
--ALTER TABLE public.component_types OWNER TO RoR;

INSERT INTO component_types (id, description, sort_order, has_costs, has_hours, has_vendor, has_misc, no_entry) VALUES
(16, 'Misc.', 400, true, false, false, true, false),
(12, 'Material', 100, true, false, true, true, false),
(13, 'Labor', 200, false, true, false, true, false),
(14, 'Sub-Contractors', 300, true, false, true, false, false),
(15, 'System Percents', 600, false, false, false, false, true),
(17, 'Adjustment', 500, true, false, false, true, false);

CREATE SEQUENCE component_types_seq;
ALTER TABLE component_types
	ALTER COLUMN id SET DEFAULT NEXTVAL('component_types_seq'),
	ADD CONSTRAINT component_types_ix_component_types_description UNIQUE(description),
    ADD CONSTRAINT component_types_pk_component_types PRIMARY KEY(id),
    ADD CONSTRAINT components_ix_components UNIQUE(id, description);




