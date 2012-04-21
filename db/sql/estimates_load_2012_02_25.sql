

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


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


--
-- TOC entry 1517 (class 1259 OID 25765)
-- Dependencies: 1847 1848 1849 6
-- Name: salespeople; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--


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


--
-- TOC entry 1522 (class 1259 OID 25792)
-- Dependencies: 1859 6
-- Name: taxtypes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--


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



--
-- TOC entry 1987 (class 0 OID 25792)
-- Dependencies: 1522
-- Data for Name: taxtypes; Type: TABLE DATA; Schema: public; Owner: postgres
--



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
