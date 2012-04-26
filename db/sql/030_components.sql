-- 030_components.sql


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

-- DROP TABLE COMPONENTS;

CREATE TABLE components (
    id integer NOT NULL,
    component_type_id integer NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    defaults_id integer,
    apply_pct_mask integer DEFAULT 0 NOT NULL,
    calc_only boolean DEFAULT false NOT NULL,
    sort_priority character(1) DEFAULT 'M'::bpchar NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deactivated boolean
 );
-- ALTER TABLE public.components OWNER TO RoR;

INSERT INTO components (id, component_type_id, description, defaults_id, apply_pct_mask, calc_only, sort_priority, deactivated) VALUES
(1, 15, 'Overhead', 3, 11, false, 'M', false),
(2, 15, 'Markup', 4, 7, false, 'M', false),
(3, 15, 'Tax', NULL, 11, true, 'Y', false),
(4, 12, 'Rooftop Equipment', NULL, 0, false, 'M', false),
(28, 14, 'Rigging', NULL, 0, false, 'M', false),
(30, 14, 'Roofer', NULL, 0, false, 'M', false),
(32, 14, 'Balancer', NULL, 0, false, 'M', false),
(34, 14, 'Control Wiring', NULL, 0, false, 'M', false),
(36, 14, 'Core Boring', NULL, 0, false, 'M', false),
(38, 12, 'Dunnage', NULL, 0, false, 'M', false),
(40, 12, 'Refrigerant Piping', NULL, 0, false, 'M', false),
(42, 12, 'Drain Piping', NULL, 0, false, 'M', false),
(44, 12, 'Hangers', NULL, 0, false, 'M', false),
(46, 12, 'Refrigerant', NULL, 0, false, 'M', false),
(48, 13, 'Refrigerant Piping', NULL, 0, false, 'M', false),
(50, 13, 'Leak Tst Evac & Chrg', NULL, 0, false, 'M', false),
(52, 12, 'Annunciators', NULL, 0, false, 'M', false),
(54, 12, 'Breeching', NULL, 0, false, 'M', false),
(55, 12, 'Test Component', NULL, 0, false, 'M', true),
(56, 16, 'Permits', NULL, 0, false, 'M', false),
(58, 16, 'Other Misc.', NULL, 0, false, 'M', true),
(59, 17, 'Risk Allowance', NULL, 0, false, 'M', false),
(61, 12, 'Tower', NULL, 0, false, 'M', false),
(63, 12, 'Pipe', NULL, 0, false, 'M', false),
(65, 12, 'Glycol', NULL, 0, false, 'M', false),
(67, 13, 'Other Labor', NULL, 0, false, 'M', true),
(69, 14, 'Piping Subcontract', NULL, 0, false, 'M', false),
(71, 14, 'Welder', NULL, 0, false, 'M', false),
(73, 12, 'Other Material', NULL, 0, false, 'M', true),
(75, 12, 'Pumps & Spec.', NULL, 0, false, 'M', false),
(77, 13, 'Balancer', NULL, 0, false, 'M', false),
(79, 12, 'Flue Insulation', NULL, 0, false, 'M', false),
(81, 12, 'Make-Up Air Unit', NULL, 0, false, 'M', false),
(83, 14, 'Demo Contractor', NULL, 0, false, 'M', false),
(5, 12, 'Curb', NULL, 0, false, 'M', false),
(6, 12, 'Economizer', NULL, 0, false, 'M', false),
(7, 12, 'Controls', NULL, 0, false, 'M', false),
(8, 12, 'Smoke Detectors', NULL, 0, false, 'M', false),
(9, 14, 'Annunciators', NULL, 0, false, 'M', false),
(10, 12, 'RGD''s', NULL, 0, false, 'M', false),
(11, 12, 'Fire Dampers', NULL, 0, false, 'M', false),
(12, 12, 'Smoke Dampers', NULL, 0, false, 'M', false),
(13, 12, 'Exhaust Fans', NULL, 0, false, 'M', false),
(14, 12, 'Starters', NULL, 0, false, 'M', false),
(15, 12, 'Louvers', NULL, 0, false, 'M', false),
(16, 12, 'Roof/Wall Caps', NULL, 0, false, 'M', false),
(17, 12, 'Burgular Bars', NULL, 0, false, 'M', false),
(18, 12, 'VFD''s', NULL, 0, false, 'M', false),
(19, 13, 'Rigging', NULL, 0, false, 'M', false),
(20, 13, 'Assembly', NULL, 0, false, 'M', false),
(21, 13, 'Start & Test', NULL, 0, false, 'M', false),
(22, 13, 'Install Controls', NULL, 0, false, 'M', false),
(23, 13, 'Disconnect Service', NULL, 0, false, 'M', false),
(24, 13, 'Reclaim Refrigerant', NULL, 0, false, 'M', false),
(25, 13, 'Install Econo', NULL, 0, false, 'M', false),
(26, 14, 'Sheetmetal', NULL, 0, false, 'M', false),
(29, 14, 'Duct Insulation', NULL, 0, false, 'M', false),
(31, 14, 'Steel', NULL, 0, false, 'M', false),
(33, 14, 'Power Wiring', NULL, 0, false, 'M', false),
(35, 14, 'Gas Piping', NULL, 0, false, 'M', false),
(37, 12, 'Split System Equip', NULL, 0, false, 'M', false),
(39, 12, 'Isolators', NULL, 0, false, 'M', false),
(41, 12, 'Refrigerant Specialties', NULL, 0, false, 'M', false),
(43, 12, 'Condensate Pump', NULL, 0, false, 'M', false),
(45, 12, 'Pipe Insulation', NULL, 0, false, 'M', false),
(47, 12, 'Drain Pan', NULL, 0, false, 'M', false),
(49, 13, 'Pipe Drain', NULL, 0, false, 'M', false),
(51, 14, 'Concrete Pad', NULL, 0, false, 'M', false),
(53, 12, 'Boiler', NULL, 0, false, 'M', false),
(57, 16, 'Stamps', NULL, 0, false, 'M', false),
(60, 17, 'Vague Requirements Allowance', NULL, 0, false, 'M', false),
(62, 12, 'Pumps', NULL, 0, false, 'M', false),
(64, 12, 'Pipe Fittings', NULL, 0, false, 'M', false),
(66, 12, 'Glycol Pump Start', NULL, 0, false, 'M', false),
(68, 13, 'Fill System', NULL, 0, false, 'M', false),
(70, 14, 'Pipe Insulation', NULL, 0, false, 'M', false),
(72, 14, 'Other Subcontract', NULL, 0, false, 'M', true),
(74, 12, 'Chiller', NULL, 0, false, 'M', false),
(76, 12, 'Ductless Split System Eq.', NULL, 0, false, 'M', false),
(78, 12, 'Heater / Furnace', NULL, 0, false, 'M', false),
(80, 14, 'Flue Insulation Subcontract', NULL, 0, false, 'M', false),
(82, 12, 'Roof / Wall Caps', NULL, 0, false, 'M', true),
(85, 15, 'Labor Cost', 1, 2, true, 'A', false),
(86, 15, 'Estimate', NULL, 0, true, 'Z', false);

CREATE SEQUENCE components_seq;
ALTER TABLE ONLY components
    ALTER COLUMN id SET DEFAULT NEXTVAL('components_seq'),
    ADD CONSTRAINT components_pk_components PRIMARY KEY (id),
    ADD CONSTRAINT components_ix_components_type_description UNIQUE(component_type_id, description),
    ADD CONSTRAINT components_fk_defaults FOREIGN KEY (defaults_id) REFERENCES defaults(id),
    ADD CONSTRAINT components_fk_component_types FOREIGN KEY (id) REFERENCES component_types(id);


