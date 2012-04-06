

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE customers (
    cust_id integer NOT NULL,
    cust_num character varying(25) DEFAULT ''::character varying NOT NULL,
    cust_co_name character varying(50) DEFAULT ''::character varying NOT NULL,
    cust_name character varying(50) DEFAULT ''::character varying NOT NULL,
    cust_addr1 character varying(50) DEFAULT ''::character varying NOT NULL,
    cust_addr2 character varying(50) DEFAULT ''::character varying NOT NULL,
    cust_city character varying(50) DEFAULT ''::character varying NOT NULL,
    cust_zip character(10) DEFAULT ''::bpchar NOT NULL,
    cust_state_id integer NOT NULL,
    cust_phone character varying(25) DEFAULT ''::character varying NOT NULL,
    cust_fax character varying(25) DEFAULT ''::character varying NOT NULL,
    cust_walk_thru character(1) DEFAULT 'N'::bpchar NOT NULL,
    cust_bid_forms character(1) DEFAULT 'N'::bpchar NOT NULL,
    cust_control_rev character(1) DEFAULT 'N'::bpchar NOT NULL,
    cust_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 1510 (class 1259 OID 25713)
-- Dependencies: 1819 6
-- Name: deliverymethods; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE deliverymethods (
    deliv_id integer NOT NULL,
    deliv_sort_order integer NOT NULL,
    deliv_desc character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.deliverymethods OWNER TO postgres;

--
-- TOC entry 1511 (class 1259 OID 25717)
-- Dependencies: 1820 1821 6
-- Name: estimatecomponents; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estimatecomponents (
    est_comp_id integer NOT NULL,
    est_comp_est_id integer NOT NULL,
    est_comp_sys_id integer,
    est_comp_type_id integer NOT NULL,
    est_comp_sys_comp_id integer,
    est_comp_other_comp character varying(50) DEFAULT ''::character varying NOT NULL,
    est_comp_pct numeric(9,4),
    est_comp_hrs numeric(9,2),
    est_comp_costs numeric(9,2),
    est_comp_vend_id integer,
    est_comp_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.estimatecomponents OWNER TO postgres;

--
-- TOC entry 1512 (class 1259 OID 25722)
-- Dependencies: 1822 1823 1824 1825 1826 1827 1828 1829 1830 1831 6
-- Name: estimates; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estimates (
    est_id integer NOT NULL,
    est_name character varying(50) DEFAULT ''::character varying NOT NULL,
    est_bid_date timestamp without time zone NOT NULL,
    est_cust_id integer NOT NULL,
    est_salesp_id integer NOT NULL,
    est_deliv_id integer NOT NULL,
    est_bond character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_prevail_wage character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_tax_status_id integer NOT NULL,
    est_state_id integer NOT NULL,
    est_walk_thru character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_walk_thru_date timestamp without time zone NOT NULL,
    est_forms character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_control_reviewed character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_total_tonage integer NOT NULL,
    est_cfm integer NOT NULL,
    est_building_sq_ft integer NOT NULL,
    est_heating_btu integer NOT NULL,
    est_job_type_id integer NOT NULL,
    est_locked character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_created_date timestamp without time zone,
    est_deleted character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_simple character(1) DEFAULT 'N'::bpchar NOT NULL,
    est_notes character varying(4000) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.estimates OWNER TO postgres;

--
-- TOC entry 1513 (class 1259 OID 25738)
-- Dependencies: 1832 6
-- Name: estimatesystems; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estimatesystems (
    est_sys_id integer NOT NULL,
    est_sys_est_id integer NOT NULL,
    est_sys_sys_id integer NOT NULL,
    est_sys_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.estimatesystems OWNER TO postgres;

--
-- TOC entry 1514 (class 1259 OID 25742)
-- Dependencies: 1833 6
-- Name: jobcomponents; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE jobcomponents (
    job_comp_id integer NOT NULL,
    job_comp_job_id integer NOT NULL,
    job_comp_sys_comp_id integer NOT NULL,
    job_comp_other_comp character varying(50),
    job_comp_hrs numeric(18,0),
    job_comp_costs numeric(19,2),
    job_comp_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.jobcomponents OWNER TO postgres;

--
-- TOC entry 1515 (class 1259 OID 25746)
-- Dependencies: 1834 1835 1836 1837 1838 1839 1840 1841 6
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE jobs (
    job_id integer NOT NULL,
    job_est_id integer NOT NULL,
    job_name character varying(50) DEFAULT ''::character varying NOT NULL,
    job_bid_date timestamp without time zone NOT NULL,
    job_cust_id integer NOT NULL,
    job_salesp_id integer NOT NULL,
    job_deliv_id integer NOT NULL,
    job_bond character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_prevail_wage character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_tax_status_id integer NOT NULL,
    job_walk_thru character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_walk_thru_date timestamp without time zone NOT NULL,
    job_forms character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_control_reviewed character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_total_tonage integer NOT NULL,
    job_cfm integer NOT NULL,
    job_building_sq_ft integer NOT NULL,
    job_heating_btu integer NOT NULL,
    job_job_type_id integer NOT NULL,
    job_locked character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_created_date timestamp without time zone,
    job_deleted character(1) DEFAULT 'N'::bpchar NOT NULL,
    job_deleted_date timestamp without time zone
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- TOC entry 1516 (class 1259 OID 25757)
-- Dependencies: 1842 1843 1844 1845 1846 6
-- Name: jobtypes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE jobtypes (
    job_type_id integer NOT NULL,
    job_type_desc character varying(50) DEFAULT ''::character varying NOT NULL,
    job_type_mat_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
    job_type_lab_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
    job_type_sub_prop numeric(18,0) DEFAULT (0)::numeric NOT NULL,
    job_type_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.jobtypes OWNER TO postgres;

--
-- TOC entry 1517 (class 1259 OID 25765)
-- Dependencies: 1847 1848 1849 6
-- Name: salespeople; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE salespeople (
    salesp_id integer NOT NULL,
    salesp_user_id integer NOT NULL,
    salesp_min_mu_pct numeric(18,3) DEFAULT (0)::numeric NOT NULL,
    salesp_max_mu_pct numeric(18,0) DEFAULT (0)::numeric NOT NULL,
    salesp_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.salespeople OWNER TO postgres;

--
-- TOC entry 1518 (class 1259 OID 25771)
-- Dependencies: 1850 1851 6
-- Name: staterates; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE staterates (
    state_rate_id integer NOT NULL,
    state_rate_state_id integer NOT NULL,
    state_rate_tax_type_id integer NOT NULL,
    state_rate_comp_type_id integer NOT NULL,
    state_rate_proportion numeric(18,4) DEFAULT (0)::numeric NOT NULL,
    state_rate_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.staterates OWNER TO postgres;

--
-- TOC entry 1519 (class 1259 OID 25776)
-- Dependencies: 1852 1853 6
-- Name: states; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE states (
    state_id integer NOT NULL,
    state_code character(2) DEFAULT ''::bpchar NOT NULL,
    state_desc character varying(25) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.states OWNER TO postgres;

--
-- TOC entry 1520 (class 1259 OID 25781)
-- Dependencies: 1854 1855 6
-- Name: systemcomponents; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE systemcomponents (
    sys_comp_id integer NOT NULL,
    sys_comp_comp_id integer NOT NULL,
    sys_comp_sys_id integer NOT NULL,
    sys_comp_desc character varying(50),
    sys_comp_req character(1) DEFAULT 'Y'::bpchar NOT NULL,
    sys_comp_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.systemcomponents OWNER TO postgres;

--
-- TOC entry 1522 (class 1259 OID 25792)
-- Dependencies: 1859 6
-- Name: taxtypes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE taxtypes (
    tax_type_id integer NOT NULL,
    tax_type_sort_order integer NOT NULL,
    tax_type_desc character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.taxtypes OWNER TO postgres;

--
-- TOC entry 1523 (class 1259 OID 25796)
-- Dependencies: 1860 1861 6
-- Name: terms; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE terms (
    terms_id integer NOT NULL,
    terms_sort_order integer NOT NULL,
    terms_desc character varying(50) DEFAULT ''::character varying NOT NULL,
    terms_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.terms OWNER TO postgres;

--
-- TOC entry 1524 (class 1259 OID 25801)
-- Dependencies: 1862 1863 1864 1865 1866 1867 1868 6
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    users_id integer NOT NULL,
    users_name character varying(25) DEFAULT ''::character varying NOT NULL,
    users_pass character varying(25) DEFAULT ''::character varying NOT NULL,
    users_lname character varying(50) DEFAULT ''::character varying NOT NULL,
    users_fname character varying(50) DEFAULT ''::character varying NOT NULL,
    users_login character(1) DEFAULT 'Y'::bpchar NOT NULL,
    users_deleted character(1) DEFAULT 'N'::bpchar NOT NULL,
    users_super character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 1525 (class 1259 OID 25811)
-- Dependencies: 1869 6
-- Name: vendorcomponents; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vendorcomponents (
    vend_comp_id integer NOT NULL,
    vend_comp_vend_id integer NOT NULL,
    vend_comp_sys_comp_id integer NOT NULL,
    vend_comp_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.vendorcomponents OWNER TO postgres;

--
-- TOC entry 1526 (class 1259 OID 25815)
-- Dependencies: 1870 1871 1872 1873 1874 1875 1876 1877 1878 1879 1880 1881 1882 1883 1884 1885 6
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vendors (
    vend_id integer NOT NULL,
    vend_num character varying(25) DEFAULT ''::character varying NOT NULL,
    vend_name character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_contact character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_addr1 character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_addr2 character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_city character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_zip character(10) DEFAULT ''::bpchar NOT NULL,
    vend_state_id integer NOT NULL,
    vend_phone character varying(25) DEFAULT ''::character varying NOT NULL,
    vend_fax character varying(25) DEFAULT ''::character varying NOT NULL,
    vend_terms_id integer NOT NULL,
    vend_ret_rate character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_ref character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_gl_acct character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_email character varying(50) DEFAULT ''::character varying NOT NULL,
    vend_url character varying(250) DEFAULT ''::character varying NOT NULL,
    vend_comments character varying(4000) DEFAULT ''::character varying NOT NULL,
    vend_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- TOC entry 1527 (class 1259 OID 25837)
-- Dependencies: 1886 6
-- Name: vendorsystems; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vendorsystems (
    vs_id integer NOT NULL,
    vs_vend_id integer NOT NULL,
    vs_sys_id integer NOT NULL,
    vs_deleted character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.vendorsystems OWNER TO postgres;



INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (1, '1', 'Moksa, Inc', 'DiPaola, Vince', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'Y');
INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (4, '4', 'Joe''s Beauty Parlor', 'Joe Barber', '', '', '', '11111     ', 1, '', '', 'N', 'N', 'N', ' ');
INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (5, '5', 'Joe''s Auto Parts', 'Joe Smith', '', '', '', '          ', 1, '', '', 'Y', 'Y', 'N', ' ');
INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (6, '6', 'Joe''s Sandwich Shop', 'Joe Cook', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', ' ');
INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (7, '7', 'Moksa', 'Dave', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'N');
INSERT INTO customers (cust_id, cust_num, cust_co_name, cust_name, cust_addr1, cust_addr2, cust_city, cust_zip, cust_state_id, cust_phone, cust_fax, cust_walk_thru, cust_bid_forms, cust_control_rev, cust_deleted) VALUES (12, '10', 'testing 1 2 3', 'testing 3 4 5', '', '', '', '          ', 1, '', '', 'N', 'N', 'N', 'N');


--
-- TOC entry 1975 (class 0 OID 25713)
-- Dependencies: 1510
-- Data for Name: deliverymethods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO deliverymethods (deliv_id, deliv_sort_order, deliv_desc) VALUES (1, 10, 'Mailed');
INSERT INTO deliverymethods (deliv_id, deliv_sort_order, deliv_desc) VALUES (2, 20, 'Faxed');
INSERT INTO deliverymethods (deliv_id, deliv_sort_order, deliv_desc) VALUES (3, 30, 'Delivered');


--
-- TOC entry 1976 (class 0 OID 25717)
-- Dependencies: 1511
-- Data for Name: estimatecomponents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (56, 9, 7, 12, 54, '', NULL, NULL, 25.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (57, 9, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (58, 9, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (59, 9, 7, 13, 217, '', NULL, 34.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (60, 9, 7, 14, 221, '', NULL, NULL, NULL, NULL, 'Y');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (61, 9, 12, 16, 411, '', NULL, NULL, 55.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (62, 9, 12, 17, 409, '', NULL, NULL, NULL, NULL, 'Y');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (63, 9, 7, 13, 217, '', NULL, NULL, NULL, NULL, 'Y');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (64, 9, 7, 14, 221, '', NULL, NULL, 13.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (65, 9, 12, 16, 411, '', NULL, NULL, NULL, NULL, 'Y');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (66, 9, 12, 17, 409, '', NULL, NULL, 10000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (67, 9, 7, 12, 209, '', NULL, NULL, 26.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (68, 14, 3, 12, 182, '', NULL, NULL, 24.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (69, 14, 3, 12, 189, '', NULL, NULL, 37.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (70, 14, 3, 14, 198, '', NULL, NULL, 22.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (71, 14, 3, 14, 203, '', NULL, NULL, 19.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (72, 14, 12, 16, 411, '', NULL, NULL, 38.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (73, 14, 12, 17, 409, '', NULL, NULL, 16.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (74, 14, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (75, 14, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (76, 14, 11, 12, 148, '', NULL, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (77, 14, 11, 12, 149, '', NULL, NULL, 64.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (78, 14, 11, 12, 154, '', NULL, NULL, 18.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (79, 14, 11, 13, 164, '', NULL, 12.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (80, 14, 11, 13, 165, '', NULL, 7.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (81, 14, 11, 13, 166, '', NULL, 2.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (82, 14, 11, 13, 167, '', NULL, 6.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (83, 18, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (84, 18, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (85, 18, 5, 12, 365, '', NULL, NULL, 23.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (86, 18, 5, 13, 366, '', NULL, 10.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (87, 18, 12, 16, 410, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (88, 18, 12, 17, 409, '', NULL, NULL, 234.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (89, 19, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (90, 19, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (91, 20, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (92, 20, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (93, 21, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (94, 21, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (95, 21, 1, 12, 32, '', NULL, NULL, 300.00, 1, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (96, 21, 1, 12, 1, '', NULL, NULL, 1900.00, 2, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (97, 21, 1, 12, 5, '', NULL, NULL, 200.00, 2, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (98, 21, 1, 13, 37, '', NULL, 2.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (99, 21, 1, 13, 40, '', NULL, 4.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (100, 21, 1, 13, 43, '', NULL, 4.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (101, 21, 1, 14, 44, '', NULL, NULL, 250.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (102, 21, 1, 14, 47, '', NULL, NULL, 1000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (103, 21, 1, 14, 49, '', NULL, NULL, 2200.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (104, 21, 1, 14, 50, '', NULL, NULL, 550.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (105, 21, 1, 14, 52, '', NULL, NULL, 3000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (106, 21, 1, 14, 53, '', NULL, NULL, NULL, NULL, 'Y');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (107, 22, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (108, 22, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (109, 22, 4, 12, 360, '', NULL, NULL, 1500.00, 10, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (110, 24, 12, 15, 403, '', 8.0012, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (111, 24, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (112, 24, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (113, 24, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (114, 24, 1, 12, 28, '', NULL, NULL, 34.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (115, 24, 1, 13, 37, '', NULL, 12.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (116, 24, 1, 14, 44, '', NULL, NULL, 45.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (117, 9, 12, 15, 403, '', 8.0012, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (118, 9, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (119, 25, 12, 15, 403, '', 8.0012, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (120, 25, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (121, 25, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (122, 25, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (123, 25, 13, 12, 412, '', NULL, NULL, 24.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (124, 25, 13, 12, 436, '', NULL, NULL, 34.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (125, 25, 13, 12, NULL, 'extra', NULL, NULL, 12.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (126, 25, 13, 13, 452, '', NULL, 56.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (127, 25, 13, 14, 465, '', NULL, NULL, 78.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (128, 25, 13, 14, 466, '', NULL, NULL, 90.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (129, 26, 12, 15, 403, '', 48.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (130, 26, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (131, 26, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (132, 26, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (133, 26, 10, 12, 343, '', NULL, NULL, 23.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (134, 26, 10, 12, 344, '', NULL, NULL, 45.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (135, 26, 10, 12, NULL, 'extra', NULL, NULL, 12.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (136, 26, 10, 13, 138, '', NULL, 22.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (137, 26, 10, 13, 129, '', NULL, 33.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (138, 26, 10, 14, 351, '', NULL, NULL, 56.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (139, 26, 10, 14, 352, '', NULL, NULL, 67.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (140, 26, 1, 12, 28, '', NULL, NULL, 34.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (141, 26, 1, 13, 37, '', NULL, 12.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (142, 26, 1, 14, 44, '', NULL, NULL, 34.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (143, 27, 12, 15, 403, '', 48.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (144, 27, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (145, 27, 12, 15, 406, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (146, 27, 12, 15, 407, '', 6.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (147, 27, 13, 12, 413, '', NULL, NULL, 6000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (148, 27, 13, 12, 414, '', NULL, NULL, 3400.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (149, 27, 13, 12, 418, '', NULL, NULL, 500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (150, 27, 13, 12, 423, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (151, 27, 13, 12, 426, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (152, 27, 13, 12, 428, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (153, 27, 13, 12, 429, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (154, 27, 13, 12, 430, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (155, 27, 13, 12, 432, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (156, 27, 13, 12, 433, '', NULL, NULL, 350.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (157, 27, 13, 12, 435, '', NULL, NULL, 750.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (158, 27, 13, 12, 436, '', NULL, NULL, 35.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (159, 27, 13, 12, 437, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (160, 27, 13, 12, 438, '', NULL, NULL, 500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (161, 27, 13, 12, 446, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (162, 27, 13, 12, 449, '', NULL, NULL, 500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (163, 27, 13, 12, 451, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (164, 27, 13, 12, NULL, 'Test Componet', NULL, NULL, 234.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (165, 27, 13, 13, 452, '', NULL, 0.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (166, 27, 13, 13, 456, '', NULL, 16.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (167, 27, 13, 13, 462, '', NULL, 0.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (168, 27, 13, 13, 463, '', NULL, 8.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (169, 27, 13, 13, 459, '', NULL, 8.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (170, 27, 13, 13, NULL, 'Pipe Boiler', NULL, 21.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (171, 27, 13, 14, 466, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (172, 27, 13, 14, 467, '', NULL, NULL, 1500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (173, 27, 13, 14, 469, '', NULL, NULL, 3000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (174, 27, 13, 14, 471, '', NULL, NULL, 2000.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (175, 27, 13, 14, 473, '', NULL, NULL, 50.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (176, 27, 13, 14, 474, '', NULL, NULL, 6900.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (177, 27, 13, 14, 475, '', NULL, NULL, 700.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (178, 27, 13, 14, 476, '', NULL, NULL, 3500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (179, 27, 13, 14, 478, '', NULL, NULL, 3500.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (180, 27, 13, 14, 479, '', NULL, NULL, 56.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (181, 27, 13, 14, 480, '', NULL, NULL, 0.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (182, 27, 13, 14, 472, '', NULL, NULL, 670.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (183, 28, 12, 15, 403, '', 48.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (184, 28, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (185, 28, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (186, 28, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (320, 29, 12, 15, 403, '', 48.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (321, 29, 12, 15, 405, '', 13.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (322, 29, 12, 15, 406, '', 8.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (323, 29, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (324, 29, 13, 12, 412, '', NULL, NULL, 2.00, 9, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (325, 29, 13, 12, 413, '', NULL, NULL, 3.00, 10, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (326, 29, 13, 12, 414, '', NULL, NULL, 4.00, 2, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (327, 29, 13, 12, 415, '', NULL, NULL, 5.00, 3, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (328, 29, 13, 12, 416, '', NULL, NULL, 6.00, 1, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (329, 29, 13, 14, 469, '', NULL, NULL, 5.00, 1, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (330, 29, 13, 14, 473, '', NULL, NULL, 345.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (331, 29, 13, 13, 452, '', NULL, 1.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (332, 29, 13, 13, 454, '', NULL, 3.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (333, 29, 13, 13, 455, '', NULL, 24.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (334, 29, 13, 13, 461, '', NULL, 56.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (335, 29, 13, 12, NULL, 'abc', NULL, NULL, 23.00, 9, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (336, 29, 13, 12, NULL, 'abc', NULL, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (337, 29, 12, 17, 409, '', NULL, NULL, 23.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (338, 29, 13, 12, 417, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (339, 29, 13, 12, 418, '', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (340, 29, 13, 12, 419, '', NULL, NULL, 9.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (341, 29, 13, 12, 420, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (342, 29, 13, 12, 421, '', NULL, NULL, 2.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (343, 29, 13, 12, 422, '', NULL, NULL, 3.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (344, 29, 13, 12, 423, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (345, 29, 13, 12, 424, '', NULL, NULL, 5.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (346, 29, 13, 12, 425, '', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (347, 29, 13, 12, 426, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (348, 29, 13, 12, 428, '', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (349, 29, 13, 12, 429, '', NULL, NULL, 9.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (350, 29, 13, 12, 430, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (351, 29, 13, 12, 431, '', NULL, NULL, 2.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (352, 29, 13, 12, 432, '', NULL, NULL, 3.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (353, 29, 13, 12, 433, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (354, 29, 13, 12, 434, '', NULL, NULL, 5.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (355, 29, 13, 12, 435, '', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (356, 29, 13, 12, 436, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (357, 29, 13, 12, 437, '', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (358, 29, 13, 12, 438, '', NULL, NULL, 9.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (359, 29, 13, 12, 439, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (360, 29, 13, 12, 440, '', NULL, NULL, 2.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (361, 29, 13, 12, 441, '', NULL, NULL, 3.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (362, 29, 13, 12, 442, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (363, 29, 13, 12, 443, '', NULL, NULL, 5.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (364, 29, 13, 12, 444, '', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (365, 29, 13, 12, 445, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (366, 29, 13, 12, 446, '', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (367, 29, 13, 12, 447, '', NULL, NULL, 9.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (368, 29, 13, 12, 448, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (369, 29, 13, 12, 449, '', NULL, NULL, 2.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (370, 29, 13, 12, 450, '', NULL, NULL, 3.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (371, 29, 13, 12, 451, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (372, 29, 13, 12, 419, '', NULL, NULL, 5.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (373, 29, 13, 12, NULL, 'qqq', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (374, 29, 13, 13, 456, '', NULL, 1.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (375, 29, 13, 13, 457, '', NULL, 2.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (376, 29, 13, 13, 458, '', NULL, 3.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (377, 29, 13, 13, 459, '', NULL, 4.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (378, 29, 13, 13, 460, '', NULL, 5.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (379, 29, 13, 13, 462, '', NULL, 6.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (380, 29, 13, 13, 463, '', NULL, 7.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (381, 29, 13, 13, 456, '', NULL, 8.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (382, 29, 13, 13, NULL, 'www', NULL, 9.00, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (383, 29, 13, 14, 465, '', NULL, NULL, 1.00, 9, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (384, 29, 13, 14, 466, '', NULL, NULL, 2.00, 2, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (385, 29, 13, 14, 467, '', NULL, NULL, 3.00, 2, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (386, 29, 13, 14, 468, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (387, 29, 13, 14, 470, '', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (388, 29, 13, 14, 471, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (389, 29, 13, 14, 472, '', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (390, 29, 13, 14, 474, '', NULL, NULL, 9.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (391, 29, 13, 14, 475, '', NULL, NULL, 1.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (392, 29, 13, 14, 476, '', NULL, NULL, 2.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (393, 29, 13, 14, 477, '', NULL, NULL, 3.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (394, 29, 13, 14, 478, '', NULL, NULL, 4.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (395, 29, 13, 14, 479, '', NULL, NULL, 5.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (396, 29, 13, 14, 480, '', NULL, NULL, 6.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (397, 29, 13, 14, 467, '', NULL, NULL, 7.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (398, 29, 13, 14, NULL, 'eee', NULL, NULL, 8.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (399, 29, 12, 16, 411, '', NULL, NULL, 23.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (400, 29, 12, 16, 410, '', NULL, NULL, 234.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (401, 29, 12, 16, NULL, 'qas', NULL, NULL, 333.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (402, 29, 12, 17, 408, '', NULL, NULL, 22.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (403, 29, 12, 17, NULL, 'help', NULL, NULL, 11.00, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (404, 30, 12, 15, 403, '', 48.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (405, 30, 12, 15, 405, '', 12.5000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (406, 30, 12, 15, 406, '', 10.0000, NULL, NULL, NULL, 'N');
INSERT INTO estimatecomponents (est_comp_id, est_comp_est_id, est_comp_sys_id, est_comp_type_id, est_comp_sys_comp_id, est_comp_other_comp, est_comp_pct, est_comp_hrs, est_comp_costs, est_comp_vend_id, est_comp_deleted) VALUES (407, 30, 12, 15, 407, '', 0.0000, NULL, NULL, NULL, 'N');


--
-- TOC entry 1977 (class 0 OID 25722)
-- Dependencies: 1512
-- Data for Name: estimates; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (1, 'Bid 1', '2001-12-21 14:00:00', 5, 3, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-03-16 10:06:27', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (2, 'Bid 2', '2001-12-21 14:00:00', 5, 3, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-21 10:20:14', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (3, 'Bid 3', '2001-12-21 14:00:00', 5, 3, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-21 13:47:38', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (4, 'Bid 4', '2001-12-21 14:00:00', 5, 3, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-21 14:46:00', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (5, 'Bid 5', '2001-11-21 15:00:00', 4, 3, 1, 'N', 'N', 1, 1, 'N', '2001-11-21 15:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-21 15:36:58', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (6, 'Bid 6', '2001-11-25 15:00:00', 5, 3, 1, 'N', 'N', 1, 1, 'N', '2001-11-25 15:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-25 15:36:12', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (7, 'Bid 7', '2001-11-21 17:00:00', 6, 3, 1, 'N', 'N', 1, 1, 'N', '2001-08-21 17:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-11-21 17:25:48', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (9, 'New Bid', '2001-12-19 09:00:00', 4, 3, 1, 'N', 'N', 1, 1, 'N', '2001-01-19 09:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-19 09:33:09', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (11, 'Test Bid 2', '2001-12-19 12:00:00', 1, 3, 1, 'N', 'N', 1, 1, 'N', '2001-11-19 12:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-19 13:03:22', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (12, 'New Test 3', '2001-01-19 13:00:00', 7, 3, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-19 13:25:21', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (13, 'New Test 4', '2001-12-19 13:00:00', 7, 3, 1, 'N', 'N', 1, 1, 'N', '2001-10-19 13:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-19 13:26:21', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (14, 'New One', '2001-12-20 08:00:00', 7, 3, 1, 'N', 'N', 4, 1, 'N', '2001-07-20 08:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-20 08:01:06', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (17, 'newer one', '2001-12-20 08:00:00', 7, 3, 1, 'N', 'N', 1, 1, 'N', '2001-11-20 08:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-20 08:40:26', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (18, 'newest one', '2001-12-20 08:00:00', 7, 3, 1, 'N', 'N', 4, 1, 'N', '2001-08-20 08:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2001-12-20 08:57:28', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (19, '73 Washington Ave', '2002-01-15 10:00:00', 7, 4, 2, 'N', 'N', 4, 1, 'N', '2002-01-15 10:00:00', 'N', 'N', 70, 28200, 26971, 840000, 1, 'N', '2002-01-15 10:47:20', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (20, 'YALE VISITOR CENTER', '2002-01-18 14:00:00', 7, 3, 2, 'N', 'N', 1, 1, 'Y', '2002-01-04 03:00:00', 'Y', 'Y', 0, 0, 0, 0, 1, 'N', '2002-01-16 08:30:43', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (21, 'RTU Test', '2002-02-18 15:00:00', 12, 4, 2, 'N', 'N', 3, 1, 'N', '2002-01-18 15:00:00', 'N', 'N', 2, 800, 300, 10000, 1, 'N', '2002-02-18 15:46:36', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (22, 'jpe Cool', '2002-05-18 16:00:00', 7, 4, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-02-18 16:18:09', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (23, 'JPE Cool 1', '2002-06-18 16:00:00', 7, 4, 1, 'N', 'N', 1, 1, 'N', '2000-01-01 00:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-02-18 16:21:23', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (24, 'not simple 1', '2002-06-06 15:00:00', 7, 3, 1, 'N', 'N', 5, 1, 'N', '2002-02-06 15:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-06-06 15:26:09', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (25, 'dave simple 1', '2002-06-06 15:00:00', 7, 1, 1, 'N', 'N', 1, 1, 'N', '2002-03-06 15:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-06-06 15:45:20', 'N', 'Y', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (26, 'dave reg 1', '2002-06-06 15:00:00', 7, 1, 1, 'N', 'N', 3, 1, 'N', '2002-03-06 15:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-06-06 15:54:59', 'N', 'N', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (27, 'Stop & Shop Boiler Replacement', '2002-07-05 14:00:00', 7, 4, 2, 'N', 'N', 3, 1, 'N', '2002-03-05 14:00:00', 'N', 'N', 0, 0, 0, 1500000, 1, 'N', '2002-07-05 14:06:31', 'N', 'Y', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (28, 'Stop & Shop Ductless Split', '2002-07-05 14:00:00', 7, 4, 1, 'N', 'N', 3, 1, 'N', '2002-06-05 14:00:00', 'N', 'N', 21, 0, 0, 0, 1, 'N', '2002-07-05 14:28:47', 'N', 'Y', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (29, 'test0808', '2002-08-08 09:00:00', 7, 1, 1, 'N', 'N', 1, 1, 'N', '2002-01-08 09:00:00', 'N', 'N', 23, 45, 34, 234, 1, 'N', '2002-08-08 09:34:29', 'N', 'Y', '');
INSERT INTO estimates (est_id, est_name, est_bid_date, est_cust_id, est_salesp_id, est_deliv_id, est_bond, est_prevail_wage, est_tax_status_id, est_state_id, est_walk_thru, est_walk_thru_date, est_forms, est_control_reviewed, est_total_tonage, est_cfm, est_building_sq_ft, est_heating_btu, est_job_type_id, est_locked, est_created_date, est_deleted, est_simple, est_notes) VALUES (30, 'test0808a', '2002-08-08 09:00:00', 7, 1, 1, 'N', 'N', 1, 1, 'N', '2002-07-08 09:00:00', 'N', 'N', 0, 0, 0, 0, 1, 'N', '2002-08-08 09:46:15', 'N', 'Y', '');


--
-- TOC entry 1978 (class 0 OID 25738)
-- Dependencies: 1513
-- Data for Name: estimatesystems; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (1, 9, 7, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (2, 14, 3, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (3, 14, 11, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (4, 18, 5, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (5, 21, 1, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (6, 22, 4, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (7, 24, 1, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (8, 25, 10, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (9, 25, 1, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (10, 26, 10, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (11, 26, 1, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (12, 27, 11, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (13, 27, 5, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (14, 28, 8, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (15, 29, 7, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (16, 29, 11, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (17, 29, 9, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (18, 29, 5, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (19, 29, 10, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (20, 29, 8, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (21, 29, 4, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (22, 29, 6, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (23, 29, 1, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (24, 29, 2, 'N');
INSERT INTO estimatesystems (est_sys_id, est_sys_est_id, est_sys_sys_id, est_sys_deleted) VALUES (25, 29, 3, 'N');


--
-- TOC entry 1979 (class 0 OID 25742)
-- Dependencies: 1514
-- Data for Name: jobcomponents; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1980 (class 0 OID 25746)
-- Dependencies: 1515
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1981 (class 0 OID 25757)
-- Dependencies: 1516
-- Data for Name: jobtypes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1982 (class 0 OID 25765)
-- Dependencies: 1517
-- Data for Name: salespeople; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (1, 1, 0.000, 5, 'N');
INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (2, 2, 0.000, 5, 'N');
INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (4, 4, 0.000, 0, 'N');
INSERT INTO salespeople (salesp_id, salesp_user_id, salesp_min_mu_pct, salesp_max_mu_pct, salesp_deleted) VALUES (3, 3, 0.000, 0, 'N');


--
-- TOC entry 1983 (class 0 OID 25771)
-- Dependencies: 1518
-- Data for Name: staterates; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (1, 1, 2, 12, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (2, 1, 2, 13, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (13, 1, 5, 12, 3.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (3, 1, 2, 16, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (4, 1, 2, 17, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (5, 1, 3, 12, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (6, 1, 3, 13, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (7, 1, 3, 16, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (8, 1, 3, 17, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (9, 1, 4, 12, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (10, 1, 4, 13, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (11, 1, 4, 16, 6.0000, 'N');
INSERT INTO staterates (state_rate_id, state_rate_state_id, state_rate_tax_type_id, state_rate_comp_type_id, state_rate_proportion, state_rate_deleted) VALUES (12, 1, 4, 17, 6.0000, 'N');


--
-- TOC entry 1984 (class 0 OID 25776)
-- Dependencies: 1519
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO states (state_id, state_code, state_desc) VALUES (1, 'CT', 'Connecticut   ');
INSERT INTO states (state_id, state_code, state_desc) VALUES (2, 'MA', 'Massachusetts');
INSERT INTO states (state_id, state_code, state_desc) VALUES (3, 'NY', 'New York');
INSERT INTO states (state_id, state_code, state_desc) VALUES (4, 'RI', 'Rhode Island');


--
-- TOC entry 1985 (class 0 OID 25781)
-- Dependencies: 1520
-- Data for Name: systemcomponents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (1, 4, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (2, 5, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (3, 6, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (4, 7, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (5, 8, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (6, 6, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (7, 17, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (28, 52, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (30, 11, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (32, 10, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (34, 12, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (36, 18, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (38, 23, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (40, 25, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (42, 19, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (44, 32, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (46, 36, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (48, 35, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (50, 28, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (52, 26, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (54, 52, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (56, 45, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (57, 55, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (59, 55, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (61, 41, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (73, 56, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (8, 17, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (9, 17, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (16, 17, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (17, 17, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (18, 17, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (19, 17, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (20, 17, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (21, 17, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (22, 17, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (23, 17, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (27, 43, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (29, 13, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (31, 15, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (33, 16, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (35, 14, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (37, 20, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (39, 22, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (41, 24, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (43, 21, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (45, 34, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (47, 29, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (49, 33, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (51, 30, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (53, 31, 1, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (55, 52, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (58, 55, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (60, 55, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (62, 10, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (63, 16, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (64, 4, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (65, 22, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (66, 25, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (67, 48, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (68, 19, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (69, 35, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (70, 33, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (71, 28, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (72, 30, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (74, 56, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (75, 56, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (76, 56, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (77, 56, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (78, 56, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (79, 56, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (80, 56, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (81, 56, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (82, 56, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (83, 56, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (84, 57, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (85, 57, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (86, 57, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (87, 57, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (88, 57, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (89, 57, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (90, 57, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (91, 57, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (92, 57, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (93, 57, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (94, 57, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (95, 58, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (96, 58, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (97, 58, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (98, 58, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (99, 58, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (100, 58, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (101, 58, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (102, 58, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (103, 58, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (104, 58, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (105, 58, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (106, 52, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (109, 54, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (113, 59, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (371, 85, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (382, 3, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (392, 86, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (403, 85, 12, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (412, 52, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (414, 54, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (418, 7, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (420, 47, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (423, 38, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (427, 79, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (435, 63, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (436, 64, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (446, 12, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (460, 24, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (463, 21, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (470, 29, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (471, 80, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (475, 33, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (476, 28, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (107, 52, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (108, 52, 6, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (110, 2, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (115, 61, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (118, 63, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (415, 17, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (448, 37, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (449, 14, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (462, 19, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (111, 1, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (112, 3, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (114, 60, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (116, 62, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (119, 64, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (421, 42, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (424, 6, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (453, 77, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (124, 44, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (125, 65, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (127, 66, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (128, 67, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (129, 68, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (130, 69, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (131, 70, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (132, 71, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (133, 72, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (134, 73, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (135, 74, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (136, 75, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (137, 20, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (138, 20, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (139, 76, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (140, 76, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (141, 77, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (142, 78, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (143, 79, 6, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (144, 80, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (145, 81, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (146, 82, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (147, 83, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (148, 53, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (149, 54, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (150, 7, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (151, 11, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (152, 38, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (153, 65, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (154, 66, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (155, 44, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (156, 39, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (157, 15, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (158, 63, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (159, 64, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (160, 45, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (161, 62, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (162, 14, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (163, 18, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (164, 20, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (165, 22, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (166, 19, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (167, 21, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (168, 51, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (169, 34, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (170, 80, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (171, 70, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (172, 69, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (173, 33, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (174, 28, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (175, 26, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (176, 31, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (177, 71, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (178, 2, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (179, 1, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (180, 59, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (181, 60, 11, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (182, 74, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (183, 7, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (184, 38, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (185, 65, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (186, 66, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (187, 44, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (188, 39, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (189, 45, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (190, 75, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (191, 46, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (192, 40, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (193, 41, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (194, 14, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (195, 18, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (196, 51, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (197, 34, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (198, 70, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (199, 69, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (200, 33, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (201, 28, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (202, 31, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (203, 71, 3, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (204, 2, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (205, 1, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (206, 59, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (207, 60, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (208, 12, 11, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (209, 7, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (210, 13, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (211, 11, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (212, 39, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (213, 10, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (214, 12, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (215, 8, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (216, 14, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (217, 20, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (218, 22, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (219, 19, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (220, 21, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (221, 32, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (222, 34, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (223, 29, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (224, 35, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (225, 33, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (226, 28, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (227, 30, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (228, 26, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (229, 31, 7, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (230, 2, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (231, 1, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (232, 59, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (233, 60, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (234, 54, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (235, 7, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (236, 11, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (237, 44, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (238, 15, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (239, 63, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (240, 64, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (241, 12, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (242, 14, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (243, 20, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (244, 22, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (245, 19, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (246, 21, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (247, 34, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (248, 35, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (249, 69, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (250, 33, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (251, 26, 6, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (252, 2, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (253, 1, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (254, 59, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (255, 60, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (256, 43, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (257, 7, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (258, 47, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (259, 42, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (260, 38, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (261, 13, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (262, 11, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (263, 44, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (264, 39, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (265, 15, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (266, 45, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (267, 46, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (268, 40, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (269, 12, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (270, 8, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (271, 37, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (272, 14, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (273, 18, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (274, 20, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (275, 23, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (276, 50, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (277, 49, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (278, 24, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (279, 21, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (280, 32, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (281, 51, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (282, 34, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (283, 36, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (284, 29, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (285, 26, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (286, 31, 2, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (287, 2, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (288, 1, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (289, 59, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (290, 60, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (291, 43, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (292, 42, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (293, 38, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (294, 44, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (295, 45, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (296, 46, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (297, 40, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (298, 41, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (299, 50, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (300, 49, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (301, 48, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (302, 19, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (303, 21, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (304, 51, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (305, 33, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (306, 28, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (307, 30, 8, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (308, 2, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (309, 1, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (310, 59, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (311, 60, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (312, 7, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (313, 38, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (314, 65, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (315, 66, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (316, 44, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (317, 39, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (318, 45, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (319, 46, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (320, 40, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (321, 41, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (322, 14, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (323, 18, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (324, 68, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (325, 22, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (326, 50, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (327, 48, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (328, 19, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (329, 21, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (330, 51, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (331, 34, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (332, 36, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (333, 70, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (334, 69, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (335, 33, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (336, 28, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (337, 31, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (338, 71, 9, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (339, 2, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (340, 1, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (341, 59, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (342, 60, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (343, 7, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (344, 38, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (345, 45, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (346, 14, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (347, 18, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (348, 22, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (349, 19, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (350, 21, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (351, 51, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (352, 34, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (353, 33, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (354, 28, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (355, 31, 10, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (356, 2, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (357, 1, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (358, 59, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (359, 60, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (360, 13, 4, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (361, 2, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (362, 1, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (363, 59, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (364, 60, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (365, 7, 5, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (366, 22, 5, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (367, 2, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (368, 1, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (369, 59, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (370, 60, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (443, 10, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (474, 69, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (372, 85, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (373, 85, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (374, 85, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (375, 85, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (376, 85, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (377, 85, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (378, 85, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (379, 85, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (380, 85, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (381, 85, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (413, 53, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (416, 74, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (437, 45, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (439, 75, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (440, 46, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (441, 40, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (447, 8, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (459, 49, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (461, 48, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (466, 51, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (467, 34, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (472, 35, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (480, 71, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (383, 3, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (384, 3, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (385, 3, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (386, 3, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (387, 3, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (388, 3, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (389, 3, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (390, 3, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (391, 3, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (405, 2, 12, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (407, 3, 12, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (409, 59, 12, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (411, 56, 12, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (422, 76, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (425, 13, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (429, 66, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (430, 44, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (431, 78, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (432, 39, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (438, 62, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (442, 41, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (445, 4, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (450, 61, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (454, 23, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (456, 22, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (457, 25, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (464, 9, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (465, 32, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (393, 86, 9, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (394, 86, 5, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (395, 86, 10, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (396, 86, 8, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (397, 86, 4, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (398, 86, 6, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (399, 86, 7, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (400, 86, 1, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (401, 86, 2, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (402, 86, 3, NULL, 'N', 'Y');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (404, 86, 12, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (406, 1, 12, NULL, 'Y', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (408, 60, 12, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (410, 57, 12, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (417, 43, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (419, 5, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (426, 11, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (428, 65, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (433, 15, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (434, 81, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (444, 16, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (451, 18, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (452, 20, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (455, 68, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (458, 50, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (468, 36, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (469, 83, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (473, 70, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (477, 30, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (478, 26, 13, NULL, 'N', 'N');
INSERT INTO systemcomponents (sys_comp_id, sys_comp_comp_id, sys_comp_sys_id, sys_comp_desc, sys_comp_req, sys_comp_deleted) VALUES (479, 31, 13, NULL, 'N', 'N');


--
-- TOC entry 1987 (class 0 OID 25792)
-- Dependencies: 1522
-- Data for Name: taxtypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO taxtypes (tax_type_id, tax_type_sort_order, tax_type_desc) VALUES (1, 10, 'Tax Exempt');
INSERT INTO taxtypes (tax_type_id, tax_type_sort_order, tax_type_desc) VALUES (2, 20, 'New Construction');
INSERT INTO taxtypes (tax_type_id, tax_type_sort_order, tax_type_desc) VALUES (3, 30, 'Renovation');
INSERT INTO taxtypes (tax_type_id, tax_type_sort_order, tax_type_desc) VALUES (4, 40, 'Residential');
INSERT INTO taxtypes (tax_type_id, tax_type_sort_order, tax_type_desc) VALUES (5, 50, 'Manufacturing');


--
-- TOC entry 1988 (class 0 OID 25796)
-- Dependencies: 1523
-- Data for Name: terms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO terms (terms_id, terms_sort_order, terms_desc, terms_deleted) VALUES (1, 10, 'No Terms', 'N');
INSERT INTO terms (terms_id, terms_sort_order, terms_desc, terms_deleted) VALUES (2, 20, 'Due on Receipt', 'N');
INSERT INTO terms (terms_id, terms_sort_order, terms_desc, terms_deleted) VALUES (3, 30, 'Net 30 Days', 'N');
INSERT INTO terms (terms_id, terms_sort_order, terms_desc, terms_deleted) VALUES (4, 40, 'Net 60 Days', 'N');


--
-- TOC entry 1989 (class 0 OID 25801)
-- Dependencies: 1524
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users (users_id, users_name, users_pass, users_lname, users_fname, users_login, users_deleted, users_super) VALUES (1, 'davet', 'davet', 'Taylor', 'Dave', 'Y', 'N', 'Y');
INSERT INTO users (users_id, users_name, users_pass, users_lname, users_fname, users_login, users_deleted, users_super) VALUES (2, 'vince', 'vince', 'DiPaola', 'Vince', 'Y', 'N', 'Y');
INSERT INTO users (users_id, users_name, users_pass, users_lname, users_fname, users_login, users_deleted, users_super) VALUES (3, 'mikec', 'mikec', 'Chiocchio', 'Mike', 'Y', 'N', 'Y');
INSERT INTO users (users_id, users_name, users_pass, users_lname, users_fname, users_login, users_deleted, users_super) VALUES (4, 'vincec', 'vincec', 'Chiocchio', 'Vince', 'Y', 'N', 'Y');


--
-- TOC entry 1990 (class 0 OID 25811)
-- Dependencies: 1525
-- Data for Name: vendorcomponents; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1991 (class 0 OID 25815)
-- Dependencies: 1526
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (1, '20', 'Joe''s Sandwich Shop', 'Joe', 'addr1', 'addr2', 'any city', 'any zip   ', 1, '(203) 777-7777x123456', '(203) 777-7770', 2, '111111', '2222222', '33333338888-00000', 'joe@joe.com', 'www.joe.com', 'can''t beat the prices!

', 'N');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (2, '2', 'Joe''s Beauty Parlor', 'Joe', 'addr1', 'addr2', 'any city', 'any zip   ', 1, '(203) 777-7777x123457', '(203) 777-7770', 2, '111111', '2222222', '33333338888-00000', 'joe@joe.com', 'www.joe.com', 'can''t get prettier nails!', 'N');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (3, '3', 'Joe''s Computer Parts', 'joe', '', '', '', '          ', 1, '', '', 1, '', '', '', '', '', 'best prices in town.', 'N');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (4, '44', 'testing...', 'Dave T', '', '', '', '          ', 1, '', '', 1, '', '', '', '', '', '', 'Y');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (8, '55', 'Testing Again', 'Dave', '', '', '', '          ', 1, '', '', 1, '', '', '', '', '', '', 'N');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (9, '123', 'Retesting', '', '', '', '', '          ', 1, '', '', 1, '', '', '', '', '', '', 'N');
INSERT INTO vendors (vend_id, vend_num, vend_name, vend_contact, vend_addr1, vend_addr2, vend_city, vend_zip, vend_state_id, vend_phone, vend_fax, vend_terms_id, vend_ret_rate, vend_ref, vend_gl_acct, vend_email, vend_url, vend_comments, vend_deleted) VALUES (10, '122334', 'Sheetmetal Specialties', 'Fred', 'Cool Street', '', 'Branford', '06405     ', 1, '203-483-5000', '203-481-3533', 3, '', '', '', '', '', '', 'N');


--
-- TOC entry 1992 (class 0 OID 25837)
-- Dependencies: 1527
-- Data for Name: vendorsystems; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (2, 9, 11, 'Y');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (3, 9, 4, 'Y');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (4, 9, 6, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (5, 9, 3, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (6, 9, 9, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (7, 9, 10, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (9, 9, 1, 'Y');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (10, 2, 1, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (11, 1, 1, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (12, 3, 1, 'N');
INSERT INTO vendorsystems (vs_id, vs_vend_id, vs_sys_id, vs_deleted) VALUES (13, 10, 4, 'N');
