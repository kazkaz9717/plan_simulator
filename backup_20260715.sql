--
-- PostgreSQL database dump
--

\restrict IlBbePCR2ZltGRaaoZeGvOauC1J81EhzPwXZKaol82Ct3mNdbjdJiFd21YHPN0B

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg12+1)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: plan_simulator_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO plan_simulator_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO plan_simulator_db_user;

--
-- Name: device_grades; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.device_grades (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.device_grades OWNER TO plan_simulator_db_user;

--
-- Name: device_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.device_grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.device_grades_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: device_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.device_grades_id_seq OWNED BY public.device_grades.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.devices (
    id bigint NOT NULL,
    maker_id bigint NOT NULL,
    name character varying,
    price integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    release_date date,
    group_name character varying
);


ALTER TABLE public.devices OWNER TO plan_simulator_db_user;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: discount_plan_brands; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.discount_plan_brands (
    id bigint NOT NULL,
    discount_id bigint NOT NULL,
    plan_brand_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.discount_plan_brands OWNER TO plan_simulator_db_user;

--
-- Name: discount_plan_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.discount_plan_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discount_plan_brands_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: discount_plan_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.discount_plan_brands_id_seq OWNED BY public.discount_plan_brands.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.discounts (
    id bigint NOT NULL,
    name character varying,
    amount integer,
    duration_months integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    group_name character varying
);


ALTER TABLE public.discounts OWNER TO plan_simulator_db_user;

--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discounts_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: fees; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.fees (
    id bigint NOT NULL,
    name character varying,
    price integer,
    group_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.fees OWNER TO plan_simulator_db_user;

--
-- Name: fees_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.fees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fees_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: fees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.fees_id_seq OWNED BY public.fees.id;


--
-- Name: makers; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.makers (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.makers OWNER TO plan_simulator_db_user;

--
-- Name: makers_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.makers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.makers_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: makers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.makers_id_seq OWNED BY public.makers.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.options (
    id bigint NOT NULL,
    name character varying,
    price integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    group_name character varying
);


ALTER TABLE public.options OWNER TO plan_simulator_db_user;

--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.options_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.options_id_seq OWNED BY public.options.id;


--
-- Name: plan_brand_plans; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.plan_brand_plans (
    id bigint NOT NULL,
    plan_id bigint NOT NULL,
    plan_brand_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.plan_brand_plans OWNER TO plan_simulator_db_user;

--
-- Name: plan_brand_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.plan_brand_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_brand_plans_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: plan_brand_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.plan_brand_plans_id_seq OWNED BY public.plan_brand_plans.id;


--
-- Name: plan_brands; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.plan_brands (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.plan_brands OWNER TO plan_simulator_db_user;

--
-- Name: plan_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.plan_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_brands_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: plan_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.plan_brands_id_seq OWNED BY public.plan_brands.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    name character varying,
    monthly_fee integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    group_name character varying
);


ALTER TABLE public.plans OWNER TO plan_simulator_db_user;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plans_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO plan_simulator_db_user;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    name character varying,
    monthly_fee integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    group_name character varying
);


ALTER TABLE public.subscriptions OWNER TO plan_simulator_db_user;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscriptions_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: plan_simulator_db_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    password_digest character varying,
    role integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO plan_simulator_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: plan_simulator_db_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO plan_simulator_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: plan_simulator_db_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: device_grades id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.device_grades ALTER COLUMN id SET DEFAULT nextval('public.device_grades_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: discount_plan_brands id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discount_plan_brands ALTER COLUMN id SET DEFAULT nextval('public.discount_plan_brands_id_seq'::regclass);


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: fees id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.fees ALTER COLUMN id SET DEFAULT nextval('public.fees_id_seq'::regclass);


--
-- Name: makers id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.makers ALTER COLUMN id SET DEFAULT nextval('public.makers_id_seq'::regclass);


--
-- Name: options id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.options ALTER COLUMN id SET DEFAULT nextval('public.options_id_seq'::regclass);


--
-- Name: plan_brand_plans id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brand_plans ALTER COLUMN id SET DEFAULT nextval('public.plan_brand_plans_id_seq'::regclass);


--
-- Name: plan_brands id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brands ALTER COLUMN id SET DEFAULT nextval('public.plan_brands_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2026-06-20 08:21:30.636364	2026-06-20 08:21:30.636368
\.


--
-- Data for Name: device_grades; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.device_grades (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.devices (id, maker_id, name, price, created_at, updated_at, release_date, group_name) FROM stdin;
4	3	Aurora Z9 Pro	159800	2026-06-22 11:38:09.93316	2026-06-22 11:38:09.93316	2025-09-20	ハイエンド
5	3	Aurora Z9	124800	2026-06-22 11:38:09.949032	2026-06-22 11:38:09.949032	2025-09-20	ハイエンド
6	3	Aurora A5	72800	2026-06-22 11:38:09.954626	2026-06-22 11:38:09.954626	2025-03-14	スタンダード
7	4	Lumina Ultra X	189800	2026-06-22 11:38:09.959935	2026-06-22 11:38:09.959935	2025-02-01	ハイエンド
8	4	Lumina Air	65780	2026-06-22 11:38:09.978931	2026-06-22 11:38:09.978931	2025-05-23	スタンダード
9	5	Neon S10	74800	2026-06-22 11:38:09.990821	2026-06-22 11:38:09.990821	2025-07-04	スタンダード
10	5	Neon Lite	27800	2026-06-22 11:38:09.999781	2026-06-22 11:38:09.999781	2025-01-17	エントリー
\.


--
-- Data for Name: discount_plan_brands; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.discount_plan_brands (id, discount_id, plan_brand_id, created_at, updated_at) FROM stdin;
2	2	16	2026-06-22 11:38:09.333298	2026-06-22 11:38:09.333298
3	2	17	2026-06-22 11:38:09.34419	2026-06-22 11:38:09.34419
4	3	16	2026-06-22 11:38:09.387725	2026-06-22 11:38:09.387725
5	3	17	2026-06-22 11:38:09.392102	2026-06-22 11:38:09.392102
6	4	16	2026-06-22 11:38:09.423737	2026-06-22 11:38:09.423737
7	4	17	2026-06-22 11:38:09.428751	2026-06-22 11:38:09.428751
8	5	16	2026-06-22 11:38:09.448797	2026-06-22 11:38:09.448797
9	5	17	2026-06-22 11:38:09.449719	2026-06-22 11:38:09.449719
10	6	16	2026-06-22 11:38:09.470856	2026-06-22 11:38:09.470856
11	6	17	2026-06-22 11:38:09.473562	2026-06-22 11:38:09.473562
12	6	18	2026-06-22 11:38:09.474457	2026-06-22 11:38:09.474457
13	7	16	2026-06-22 11:38:09.499208	2026-06-22 11:38:09.499208
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.discounts (id, name, amount, duration_months, created_at, updated_at, group_name) FROM stdin;
2	光セット割	1100	\N	2026-06-22 11:38:09.317595	2026-06-22 11:38:09.317595	インターネットセット割
3	ホームルーターセット割	1100	\N	2026-06-22 11:38:09.383402	2026-06-22 11:38:09.383402	インターネットセット割
4	家族割（3回線以上）	1100	\N	2026-06-22 11:38:09.42001	2026-06-22 11:38:09.42001	家族割
5	家族割（2回線以上）	550	\N	2026-06-22 11:38:09.44788	2026-06-22 11:38:09.44788	家族割
6	クレカ支払い割	187	\N	2026-06-22 11:38:09.470001	2026-06-22 11:38:09.470001	支払い割
7	のりかえキャンペーン割	1100	6	2026-06-22 11:38:09.495514	2026-06-22 11:38:09.495514	キャンペーン
\.


--
-- Data for Name: fees; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.fees (id, name, price, group_name, created_at, updated_at) FROM stdin;
1	事務手数料	4950	事務手数料	2026-06-22 19:30:25.292633	2026-06-22 19:30:25.292633
2	初期設定サポート料	3300	サポート手数料	2026-06-22 19:30:25.309362	2026-06-22 19:30:25.309362
3	データ移行手数料	2200	サポート手数料	2026-06-22 19:30:25.356911	2026-06-22 19:30:25.356911
\.


--
-- Data for Name: makers; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.makers (id, name, created_at, updated_at) FROM stdin;
3	Aurora	2026-06-22 11:38:09.813121	2026-06-22 11:38:09.813121
4	Lumina	2026-06-22 11:38:09.846564	2026-06-22 11:38:09.846564
5	Neon	2026-06-22 11:38:09.866682	2026-06-22 11:38:09.866682
\.


--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.options (id, name, price, created_at, updated_at, group_name) FROM stdin;
1	保護ガラスフィルム	3300	2026-06-22 11:38:09.652788	2026-06-22 11:38:09.652788	アクセサリ
2	手帳型ケース	4400	2026-06-22 11:38:09.673264	2026-06-22 11:38:09.673264	アクセサリ
3	モバイルバッテリー	5500	2026-06-22 11:38:09.697048	2026-06-22 11:38:09.697048	アクセサリ
4	事務手数料	4950	2026-06-22 11:38:09.716185	2026-06-22 11:38:09.716185	手数料
5	初期設定サポート	3300	2026-06-22 11:38:09.736374	2026-06-22 11:38:09.736374	手数料
6	保護フィルム	1650	2026-06-22 19:30:25.167705	2026-06-22 19:30:25.167705	フィルム
7	カバー型ケース	3300	2026-06-22 19:30:25.211279	2026-06-22 19:30:25.211279	ケース
8	メモリーカード	4400	2026-06-22 19:30:25.237433	2026-06-22 19:30:25.237433	\N
\.


--
-- Data for Name: plan_brand_plans; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.plan_brand_plans (id, plan_id, plan_brand_id, created_at, updated_at) FROM stdin;
17	11	16	2026-06-22 11:38:08.91092	2026-06-22 11:38:08.91092
18	12	16	2026-06-22 11:38:08.973557	2026-06-22 11:38:08.973557
19	13	16	2026-06-22 11:38:09.00544	2026-06-22 11:38:09.00544
20	14	17	2026-06-22 11:38:09.038659	2026-06-22 11:38:09.038659
21	15	17	2026-06-22 11:38:09.075329	2026-06-22 11:38:09.075329
22	16	18	2026-06-22 11:38:09.115681	2026-06-22 11:38:09.115681
23	17	19	2026-06-22 11:38:09.131751	2026-06-22 11:38:09.131751
24	18	16	2026-06-22 11:38:09.160768	2026-06-22 11:38:09.160768
25	18	17	2026-06-22 11:38:09.164834	2026-06-22 11:38:09.164834
26	19	16	2026-06-22 11:38:09.185815	2026-06-22 11:38:09.185815
27	19	17	2026-06-22 11:38:09.187754	2026-06-22 11:38:09.187754
\.


--
-- Data for Name: plan_brands; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.plan_brands (id, name, created_at, updated_at) FROM stdin;
16	スマホMAX	2026-06-22 11:38:08.6934	2026-06-22 11:38:08.6934
17	スマホmini	2026-06-22 11:38:08.714273	2026-06-22 11:38:08.714273
18	シンプルプラン	2026-06-22 11:38:08.732691	2026-06-22 11:38:08.732691
19	キッズプラン	2026-06-22 11:38:08.745665	2026-06-22 11:38:08.745665
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.plans (id, name, monthly_fee, created_at, updated_at, group_name) FROM stdin;
11	MAX 無制限	7315	2026-06-22 11:38:08.904617	2026-06-22 11:38:08.904617	データ容量
12	MAX 〜3GB	5665	2026-06-22 11:38:08.964838	2026-06-22 11:38:08.964838	データ容量
13	MAX 〜1GB	4565	2026-06-22 11:38:09.000885	2026-06-22 11:38:09.000885	データ容量
14	mini 〜5GB	3278	2026-06-22 11:38:09.027827	2026-06-22 11:38:09.027827	データ容量
15	mini 〜1GB	2178	2026-06-22 11:38:09.071441	2026-06-22 11:38:09.071441	データ容量
16	シンプル 20GB	2970	2026-06-22 11:38:09.113215	2026-06-22 11:38:09.113215	\N
17	キッズケータイプラン	550	2026-06-22 11:38:09.129788	2026-06-22 11:38:09.129788	\N
18	かけ放題オプション	1980	2026-06-22 11:38:09.159626	2026-06-22 11:38:09.159626	通話オプション
19	5分かけ放題	880	2026-06-22 11:38:09.183672	2026-06-22 11:38:09.183672	通話オプション
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.schema_migrations (version) FROM stdin;
20260608094622
20260608094711
20260608094720
20260608094727
20260608094734
20260608094745
20260608094754
20260608094803
20260608094823
20260610064810
20260610064829
20260610105256
20260610105306
20260611044149
20260611044202
20260611044209
20260611092831
20260611092842
20260611102506
20260611105450
20260612180215
20260614021301
20260614025628
20260614025629
20260618100011
20260618102737
20260618110306
20260618111242
20260619070705
20260622120458
20260622122900
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.subscriptions (id, name, monthly_fee, created_at, updated_at, group_name) FROM stdin;
1	動画見放題パック	990	2026-06-22 11:38:09.561082	2026-06-22 11:38:09.561082	エンタメ
2	音楽聴き放題パック	880	2026-06-22 11:38:09.582586	2026-06-22 11:38:09.582586	エンタメ
3	端末保証パック	825	2026-06-22 11:38:09.591643	2026-06-22 11:38:09.591643	補償
4	セキュリティパック	330	2026-06-22 11:38:09.603694	2026-06-22 11:38:09.603694	補償
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: plan_simulator_db_user
--

COPY public.users (id, name, password_digest, role, created_at, updated_at) FROM stdin;
1	guest	$2a$12$nb/TubmzPOKLFILIIISjd.2yzb3Okt40E3oZ2oClSc21UgbVw.1LO	1	2026-06-20 08:21:33.13993	2026-06-20 08:21:33.13993
2	店長 田中	$2a$12$UzZyYlph1TyhqIS/Ew4ncu9UwLCrfAeWmr0Qjtya.R3afdjjT6JR6	1	2026-06-22 11:38:07.88264	2026-06-22 11:38:07.88264
3	スタッフ 佐藤	$2a$12$B0f7.EZcBMtAhbJZSL8I8OHLYz7.XB5jJ48Ijm8YIbLZgnMHzgKC.	0	2026-06-22 11:38:08.132685	2026-06-22 11:38:08.132685
4	スタッフ 鈴木	$2a$12$nsXJ1JjufPwsXuEkimS38ei//RVFmkXuNHSBX4J1YS6Spvq8ul5.C	0	2026-06-22 11:38:08.382828	2026-06-22 11:38:08.382828
5	スタッフ 高橋	$2a$12$WrQgqvqHoQuIMHtody3A.ePW0xSemSwCgGwyQCckpml6XxGydcRR6	0	2026-06-22 11:38:08.622043	2026-06-22 11:38:08.622043
\.


--
-- Name: device_grades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.device_grades_id_seq', 1, false);


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.devices_id_seq', 10, true);


--
-- Name: discount_plan_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.discount_plan_brands_id_seq', 13, true);


--
-- Name: discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.discounts_id_seq', 7, true);


--
-- Name: fees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.fees_id_seq', 3, true);


--
-- Name: makers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.makers_id_seq', 5, true);


--
-- Name: options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.options_id_seq', 8, true);


--
-- Name: plan_brand_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.plan_brand_plans_id_seq', 27, true);


--
-- Name: plan_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.plan_brands_id_seq', 19, true);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.plans_id_seq', 19, true);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: plan_simulator_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: device_grades device_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.device_grades
    ADD CONSTRAINT device_grades_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: discount_plan_brands discount_plan_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discount_plan_brands
    ADD CONSTRAINT discount_plan_brands_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: fees fees_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_pkey PRIMARY KEY (id);


--
-- Name: makers makers_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.makers
    ADD CONSTRAINT makers_pkey PRIMARY KEY (id);


--
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: plan_brand_plans plan_brand_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brand_plans
    ADD CONSTRAINT plan_brand_plans_pkey PRIMARY KEY (id);


--
-- Name: plan_brands plan_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brands
    ADD CONSTRAINT plan_brands_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_devices_on_maker_id; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE INDEX index_devices_on_maker_id ON public.devices USING btree (maker_id);


--
-- Name: index_discount_plan_brands_on_discount_id; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE INDEX index_discount_plan_brands_on_discount_id ON public.discount_plan_brands USING btree (discount_id);


--
-- Name: index_discount_plan_brands_on_plan_brand_id; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE INDEX index_discount_plan_brands_on_plan_brand_id ON public.discount_plan_brands USING btree (plan_brand_id);


--
-- Name: index_plan_brand_plans_on_plan_brand_id; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE INDEX index_plan_brand_plans_on_plan_brand_id ON public.plan_brand_plans USING btree (plan_brand_id);


--
-- Name: index_plan_brand_plans_on_plan_id; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE INDEX index_plan_brand_plans_on_plan_id ON public.plan_brand_plans USING btree (plan_id);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: plan_simulator_db_user
--

CREATE UNIQUE INDEX index_users_on_name ON public.users USING btree (name);


--
-- Name: devices fk_rails_32f35c5fe9; Type: FK CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_rails_32f35c5fe9 FOREIGN KEY (maker_id) REFERENCES public.makers(id);


--
-- Name: plan_brand_plans fk_rails_32f895bd32; Type: FK CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brand_plans
    ADD CONSTRAINT fk_rails_32f895bd32 FOREIGN KEY (plan_brand_id) REFERENCES public.plan_brands(id);


--
-- Name: discount_plan_brands fk_rails_7a230b32ce; Type: FK CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discount_plan_brands
    ADD CONSTRAINT fk_rails_7a230b32ce FOREIGN KEY (discount_id) REFERENCES public.discounts(id);


--
-- Name: discount_plan_brands fk_rails_89c0a1a987; Type: FK CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.discount_plan_brands
    ADD CONSTRAINT fk_rails_89c0a1a987 FOREIGN KEY (plan_brand_id) REFERENCES public.plan_brands(id);


--
-- Name: plan_brand_plans fk_rails_9643ffbdd6; Type: FK CONSTRAINT; Schema: public; Owner: plan_simulator_db_user
--

ALTER TABLE ONLY public.plan_brand_plans
    ADD CONSTRAINT fk_rails_9643ffbdd6 FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO plan_simulator_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO plan_simulator_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO plan_simulator_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO plan_simulator_db_user;


--
-- PostgreSQL database dump complete
--

\unrestrict IlBbePCR2ZltGRaaoZeGvOauC1J81EhzPwXZKaol82Ct3mNdbjdJiFd21YHPN0B

