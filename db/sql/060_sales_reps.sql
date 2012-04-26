-- 070_sales_reps.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE sales_reps (
    id integer NOT NULL,
    user_id integer NOT NULL,
    min_markup_pct numeric(18,3) DEFAULT (0)::numeric NOT NULL,
    max_markup_pct numeric(18,3) DEFAULT (0)::numeric NOT NULL,
    deactivated boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE sales_reps_seq;
ALTER TABLE sales_reps
    ALTER COLUMN id SET DEFAULT NEXTVAL('sales_reps_seq'),
    ADD CONSTRAINT sales_reps_pk_id PRIMARY KEY (id);
--    ADD CONSTRAINT sales_reps_ix_user_id UNIQUE(user_id),
--    ADD CONSTRAINT sales_reps_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);
