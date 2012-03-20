-- 010_defaults.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


--CREATE TABLE defaults (
--    id integer NOT NULL,
----    store character varying(255) DEFAULT ''::character NOT NULL,
--    name character varying(255) DEFAULT ''::character NOT NULL,
--    value numeric(19,4) NOT NULL
--);
--ALTER TABLE public.defaults OWNER TO postgres;

INSERT INTO defaults (id, store, name, value) VALUES
(1, 'Installation Rates', 'Labor Cost', 48.0000),
(3, 'Installation Rates', 'Overhead %', 10.0000),
(4, 'Installation Rates', 'Markup %', 12.5000);

--ALTER TABLE ONLY defaults
--    ADD CONSTRAINT defaults_pk_defaults PRIMARY KEY (id);

select * from defaults;


