--
-- PostgreSQL database dump
--

-- Dumped from database version 11.22 (Debian 11.22-0+deb10u1)
-- Dumped by pg_dump version 11.22 (Debian 11.22-0+deb10u1)

-- `pg_dump -U filesender -h localhost -d filesender > database.sql`

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aggregatestatisticmetadatas; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.aggregatestatisticmetadatas (
    id integer NOT NULL,
    filesenderversion character varying(170),
    lastsend timestamp without time zone
);


ALTER TABLE public.aggregatestatisticmetadatas OWNER TO filesender;

--
-- Name: aggregatestatisticmetadatasview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.aggregatestatisticmetadatasview AS
 SELECT aggregatestatisticmetadatas.id,
    aggregatestatisticmetadatas.filesenderversion,
    aggregatestatisticmetadatas.lastsend,
    date_part('day'::text, (now() - (aggregatestatisticmetadatas.lastsend)::timestamp with time zone)) AS lastsend_days_ago
   FROM public.aggregatestatisticmetadatas;


ALTER TABLE public.aggregatestatisticmetadatasview OWNER TO filesender;

--
-- Name: aggregatestatistics; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.aggregatestatistics (
    epoch timestamp without time zone NOT NULL,
    epochtype integer NOT NULL,
    eventtype integer NOT NULL,
    eventcount bigint,
    timesum numeric DEFAULT '0'::numeric NOT NULL,
    sizesum numeric DEFAULT '0'::numeric NOT NULL,
    encryptedsum numeric DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.aggregatestatistics OWNER TO filesender;

--
-- Name: dbconstantepochtypes; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantepochtypes (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantepochtypes OWNER TO filesender;

--
-- Name: dbconstantstatsevents; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantstatsevents (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantstatsevents OWNER TO filesender;

--
-- Name: aggregatestatisticsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.aggregatestatisticsview AS
 SELECT agg.epoch,
    agg.epochtype,
    agg.eventtype,
    agg.eventcount,
    agg.timesum,
    agg.sizesum,
    agg.encryptedsum,
    (agg.sizesum / (agg.eventcount)::numeric) AS sizemean,
    (agg.timesum / (agg.eventcount)::numeric) AS timemean,
    dbconstantepochtypes.description AS epochtypetext,
    dbconstantstatsevents.description AS eventtypetext
   FROM ((public.aggregatestatistics agg
     JOIN public.dbconstantepochtypes ON ((dbconstantepochtypes.id = agg.epochtype)))
     JOIN public.dbconstantstatsevents ON ((dbconstantstatsevents.id = agg.eventtype)));


ALTER TABLE public.aggregatestatisticsview OWNER TO filesender;

--
-- Name: auditlogs; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.auditlogs (
    id bigint NOT NULL,
    event character varying(32) NOT NULL,
    target_type character varying(255) NOT NULL,
    target_id character varying(255) NOT NULL,
    author_type character varying(255),
    author_id character varying(255),
    ip character varying(39) NOT NULL,
    transaction_id character varying(36),
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.auditlogs OWNER TO filesender;

--
-- Name: auditlogs_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.auditlogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auditlogs_id_seq OWNER TO filesender;

--
-- Name: auditlogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.auditlogs_id_seq OWNED BY public.auditlogs.id;


--
-- Name: auditlogsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.auditlogsview AS
 SELECT auditlogs.id,
    auditlogs.event,
    auditlogs.target_type,
    auditlogs.target_id,
    auditlogs.author_type,
    auditlogs.author_id,
    auditlogs.ip,
    auditlogs.transaction_id,
    auditlogs.created,
    date_part('day'::text, (now() - (auditlogs.created)::timestamp with time zone)) AS created_days_ago,
    (auditlogs.target_id)::bigint AS target_id_as_number
   FROM public.auditlogs;


ALTER TABLE public.auditlogsview OWNER TO filesender;

--
-- Name: authentications; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.authentications (
    id bigint NOT NULL,
    saml_user_identification_uid character varying(170) NOT NULL,
    saml_user_identification_uid_hash character varying(200),
    created timestamp without time zone,
    last_activity timestamp without time zone,
    comment character varying(100),
    passwordhash character varying(255)
);


ALTER TABLE public.authentications OWNER TO filesender;

--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authentications_id_seq OWNER TO filesender;

--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.authentications_id_seq OWNED BY public.authentications.id;


--
-- Name: avresults; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.avresults (
    id bigint NOT NULL,
    file_id integer NOT NULL,
    app_id integer NOT NULL,
    name character varying(64),
    passes boolean DEFAULT false NOT NULL,
    error boolean DEFAULT false NOT NULL,
    internaldesc character varying(255) NOT NULL,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.avresults OWNER TO filesender;

--
-- Name: avresults_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.avresults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.avresults_id_seq OWNER TO filesender;

--
-- Name: avresults_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.avresults_id_seq OWNED BY public.avresults.id;


--
-- Name: dbconstantavprograms; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantavprograms (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantavprograms OWNER TO filesender;

--
-- Name: avresultsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.avresultsview AS
 SELECT avresults.id,
    avresults.file_id,
    avresults.app_id,
    avresults.name,
    avresults.passes,
    avresults.error,
    avresults.internaldesc,
    avresults.created,
    dbconstantavprograms.description AS appname,
    date_part('day'::text, (now() - (avresults.created)::timestamp with time zone)) AS created_days_ago
   FROM (public.avresults
     JOIN public.dbconstantavprograms ON ((avresults.app_id = dbconstantavprograms.id)));


ALTER TABLE public.avresultsview OWNER TO filesender;

--
-- Name: clientlogs; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.clientlogs (
    id bigint NOT NULL,
    userid bigint,
    created timestamp without time zone NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.clientlogs OWNER TO filesender;

--
-- Name: clientlogs_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.clientlogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientlogs_id_seq OWNER TO filesender;

--
-- Name: clientlogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.clientlogs_id_seq OWNED BY public.clientlogs.id;


--
-- Name: clientlogsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.clientlogsview AS
 SELECT clientlogs.id,
    clientlogs.userid,
    clientlogs.created,
    clientlogs.message,
    date_part('day'::text, (now() - (clientlogs.created)::timestamp with time zone)) AS created_days_ago
   FROM public.clientlogs;


ALTER TABLE public.clientlogsview OWNER TO filesender;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.collections (
    id integer NOT NULL,
    transfer_id integer NOT NULL,
    parent_id integer,
    type_id integer NOT NULL,
    info character varying(2048)
);


ALTER TABLE public.collections OWNER TO filesender;

--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_id_seq OWNER TO filesender;

--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.collections_id_seq OWNED BY public.collections.id;


--
-- Name: collectiontypes; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.collectiontypes (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    description character varying(512) NOT NULL
);


ALTER TABLE public.collectiontypes OWNER TO filesender;

--
-- Name: dbconstantbrowsertypes; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantbrowsertypes (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantbrowsertypes OWNER TO filesender;

--
-- Name: dbconstantoperatingsystems; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantoperatingsystems (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantoperatingsystems OWNER TO filesender;

--
-- Name: dbconstantpasswordencodings; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbconstantpasswordencodings (
    id integer NOT NULL,
    description character varying(160) NOT NULL
);


ALTER TABLE public.dbconstantpasswordencodings OWNER TO filesender;

--
-- Name: dbtestingtablestringnumbers; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.dbtestingtablestringnumbers (
    id integer NOT NULL,
    data character varying(160) NOT NULL,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.dbtestingtablestringnumbers OWNER TO filesender;

--
-- Name: dbtestingtablestringnumbers_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.dbtestingtablestringnumbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dbtestingtablestringnumbers_id_seq OWNER TO filesender;

--
-- Name: dbtestingtablestringnumbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.dbtestingtablestringnumbers_id_seq OWNED BY public.dbtestingtablestringnumbers.id;


--
-- Name: downloadonetimepasswords; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.downloadonetimepasswords (
    tid bigint NOT NULL,
    rid integer NOT NULL,
    created timestamp without time zone NOT NULL,
    password character varying(64) NOT NULL,
    verified timestamp without time zone
);


ALTER TABLE public.downloadonetimepasswords OWNER TO filesender;

--
-- Name: downloadonetimepasswordsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.downloadonetimepasswordsview AS
 SELECT downloadonetimepasswords.tid,
    downloadonetimepasswords.rid,
    downloadonetimepasswords.created,
    downloadonetimepasswords.password,
    downloadonetimepasswords.verified,
    date_part('day'::text, (now() - (downloadonetimepasswords.created)::timestamp with time zone)) AS created_days_ago
   FROM public.downloadonetimepasswords;


ALTER TABLE public.downloadonetimepasswordsview OWNER TO filesender;

--
-- Name: filecollections; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.filecollections (
    collection_id bigint NOT NULL,
    file_id bigint NOT NULL
);


ALTER TABLE public.filecollections OWNER TO filesender;

--
-- Name: files; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.files (
    id bigint NOT NULL,
    transfer_id bigint NOT NULL,
    uid character varying(60) NOT NULL,
    name character varying(255) NOT NULL,
    mime_type character varying(255) NOT NULL,
    size bigint NOT NULL,
    encrypted_size bigint,
    upload_start timestamp without time zone,
    upload_end timestamp without time zone,
    sha1 character varying(40),
    storage_class_name character varying(60) DEFAULT 'StorageFilesystem'::character varying,
    iv character varying(24),
    aead character varying(512),
    have_avresults boolean DEFAULT false NOT NULL
);


ALTER TABLE public.files OWNER TO filesender;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO filesender;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.transfers (
    id bigint NOT NULL,
    userid bigint NOT NULL,
    user_email character varying(250) NOT NULL,
    guest_id bigint,
    lang character varying(8),
    subject character varying(250),
    message text,
    created timestamp without time zone NOT NULL,
    made_available timestamp without time zone,
    expires timestamp without time zone NOT NULL,
    expiry_extensions smallint DEFAULT 0 NOT NULL,
    status character varying(32) NOT NULL,
    options text NOT NULL,
    key_version smallint DEFAULT 0 NOT NULL,
    salt character varying(32),
    password_version smallint DEFAULT 1 NOT NULL,
    password_encoding integer DEFAULT 0 NOT NULL,
    password_hash_iterations bigint DEFAULT 150000 NOT NULL,
    client_entropy character varying(44),
    roundtriptoken character varying(44),
    guest_transfer_shown_to_user_who_invited_guest boolean DEFAULT true
);


ALTER TABLE public.transfers OWNER TO filesender;

--
-- Name: filestranferviewcopy; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.filestranferviewcopy AS
 SELECT transfers.id,
    transfers.userid,
    transfers.user_email,
    transfers.guest_id,
    transfers.lang,
    transfers.subject,
    transfers.message,
    transfers.created,
    transfers.made_available,
    transfers.expires,
    transfers.expiry_extensions,
    transfers.status,
    transfers.options,
    transfers.key_version,
    transfers.salt,
    transfers.password_version,
    transfers.password_encoding,
    transfers.password_hash_iterations,
    transfers.client_entropy,
    transfers.roundtriptoken,
    transfers.guest_transfer_shown_to_user_who_invited_guest,
    date_part('day'::text, (now() - (transfers.created)::timestamp with time zone)) AS created_days_ago,
    date_part('day'::text, (now() - (transfers.expires)::timestamp with time zone)) AS expires_days_ago,
    date_part('day'::text, (now() - (transfers.made_available)::timestamp with time zone)) AS made_available_days_ago,
    (transfers.options ~~ '%encryption":true%'::text) AS is_encrypted,
        CASE
            WHEN (transfers.password_version = 1) THEN 'user'::text
            ELSE 'generated'::text
        END AS password_origin
   FROM public.transfers;


ALTER TABLE public.filestranferviewcopy OWNER TO filesender;

--
-- Name: filesbywhoview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.filesbywhoview AS
 SELECT t.id AS transferid,
    f.name,
    f.upload_end,
    f.id AS fileid,
    f.mime_type,
    f.size,
    t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    t.created_days_ago,
    t.expires_days_ago,
    t.made_available_days_ago,
    t.is_encrypted,
    t.password_origin
   FROM public.files f,
    public.filestranferviewcopy t
  WHERE (f.transfer_id = t.id)
  ORDER BY t.id;


ALTER TABLE public.filesbywhoview OWNER TO filesender;

--
-- Name: filesview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.filesview AS
 SELECT files.id,
    files.transfer_id,
    files.uid,
    files.name,
    files.mime_type,
    files.size,
    files.encrypted_size,
    files.upload_start,
    files.upload_end,
    files.sha1,
    files.storage_class_name,
    files.iv,
    files.aead,
    files.have_avresults,
    date_part('day'::text, (now() - (files.upload_start)::timestamp with time zone)) AS upload_start_days_ago,
    date_part('day'::text, (now() - (files.upload_end)::timestamp with time zone)) AS upload_end_days_ago
   FROM public.files;


ALTER TABLE public.filesview OWNER TO filesender;

--
-- Name: guests; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.guests (
    id bigint NOT NULL,
    userid bigint NOT NULL,
    user_email character varying(250) NOT NULL,
    token character varying(60) NOT NULL,
    email character varying(255) NOT NULL,
    transfer_count integer NOT NULL,
    subject character varying(255),
    message text,
    options text NOT NULL,
    transfer_options text NOT NULL,
    status character varying(32) NOT NULL,
    created timestamp without time zone NOT NULL,
    expires timestamp without time zone,
    last_activity timestamp without time zone NOT NULL,
    reminder_count integer DEFAULT 0 NOT NULL,
    last_reminder timestamp without time zone,
    expiry_extensions smallint DEFAULT 0 NOT NULL,
    service_aup_accepted_version integer DEFAULT 0 NOT NULL,
    service_aup_accepted_time timestamp without time zone
);


ALTER TABLE public.guests OWNER TO filesender;

--
-- Name: guests_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.guests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guests_id_seq OWNER TO filesender;

--
-- Name: guests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.guests_id_seq OWNED BY public.guests.id;


--
-- Name: guestsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.guestsview AS
 SELECT guests.id,
    guests.userid,
    guests.user_email,
    guests.token,
    guests.email,
    guests.transfer_count,
    guests.subject,
    guests.message,
    guests.options,
    guests.transfer_options,
    guests.status,
    guests.created,
    guests.expires,
    guests.last_activity,
    guests.reminder_count,
    guests.last_reminder,
    guests.expiry_extensions,
    guests.service_aup_accepted_version,
    guests.service_aup_accepted_time,
    date_part('day'::text, (now() - (guests.created)::timestamp with time zone)) AS created_days_ago,
    date_part('day'::text, (now() - (guests.expires)::timestamp with time zone)) AS expires_days_ago,
    date_part('day'::text, (now() - (guests.last_activity)::timestamp with time zone)) AS last_activity_days_ago,
    date_part('day'::text, (now() - (guests.last_reminder)::timestamp with time zone)) AS last_reminder_days_ago,
    date_part('day'::text, (now() - (guests.service_aup_accepted_time)::timestamp with time zone)) AS service_aup_accepted_time_days_ago,
    (guests.expires < now()) AS expired,
    ((guests.status)::text = 'available'::text) AS is_available
   FROM public.guests;


ALTER TABLE public.guestsview OWNER TO filesender;

--
-- Name: metadatas; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.metadatas (
    id integer NOT NULL,
    schemaversion integer NOT NULL,
    created timestamp without time zone NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.metadatas OWNER TO filesender;

--
-- Name: metadatas_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.metadatas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatas_id_seq OWNER TO filesender;

--
-- Name: metadatas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.metadatas_id_seq OWNED BY public.metadatas.id;


--
-- Name: ratelimithistorys; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.ratelimithistorys (
    id bigint NOT NULL,
    created timestamp without time zone NOT NULL,
    author_context_type character varying(255) NOT NULL,
    author_context_id character varying(255) NOT NULL,
    action character varying(40) NOT NULL,
    event character varying(255) NOT NULL,
    target_context_type character varying(255) NOT NULL,
    target_context_id character varying(255)
);


ALTER TABLE public.ratelimithistorys OWNER TO filesender;

--
-- Name: ratelimithistorys_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.ratelimithistorys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ratelimithistorys_id_seq OWNER TO filesender;

--
-- Name: ratelimithistorys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.ratelimithistorys_id_seq OWNED BY public.ratelimithistorys.id;


--
-- Name: ratelimithistorysview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.ratelimithistorysview AS
 SELECT ratelimithistorys.id,
    ratelimithistorys.created,
    ratelimithistorys.author_context_type,
    ratelimithistorys.author_context_id,
    ratelimithistorys.action,
    ratelimithistorys.event,
    ratelimithistorys.target_context_type,
    ratelimithistorys.target_context_id,
    date_part('day'::text, (now() - (ratelimithistorys.created)::timestamp with time zone)) AS created_days_ago
   FROM public.ratelimithistorys;


ALTER TABLE public.ratelimithistorysview OWNER TO filesender;

--
-- Name: recipients; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.recipients (
    id integer NOT NULL,
    transfer_id integer NOT NULL,
    email character varying(255) NOT NULL,
    token character varying(60) NOT NULL,
    created timestamp without time zone NOT NULL,
    last_activity timestamp without time zone,
    options text NOT NULL,
    reminder_count integer DEFAULT 0 NOT NULL,
    last_reminder timestamp without time zone
);


ALTER TABLE public.recipients OWNER TO filesender;

--
-- Name: recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipients_id_seq OWNER TO filesender;

--
-- Name: recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.recipients_id_seq OWNED BY public.recipients.id;


--
-- Name: shredfiles; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.shredfiles (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    errormessage character varying(300)
);


ALTER TABLE public.shredfiles OWNER TO filesender;

--
-- Name: shredfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.shredfiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shredfiles_id_seq OWNER TO filesender;

--
-- Name: shredfiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.shredfiles_id_seq OWNED BY public.shredfiles.id;


--
-- Name: statlogs; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.statlogs (
    id bigint NOT NULL,
    event character varying(32) NOT NULL,
    target_type character varying(255) NOT NULL,
    size bigint,
    time_taken bigint,
    additional_attributes text,
    created timestamp without time zone NOT NULL,
    browser integer,
    os integer,
    is_encrypted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.statlogs OWNER TO filesender;

--
-- Name: statlogs_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.statlogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statlogs_id_seq OWNER TO filesender;

--
-- Name: statlogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.statlogs_id_seq OWNED BY public.statlogs.id;


--
-- Name: statlogsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.statlogsview AS
 SELECT base.id,
    base.event,
    base.target_type,
    base.size,
    base.time_taken,
    base.additional_attributes,
    base.created,
    base.browser,
    base.os,
    base.is_encrypted,
    date_part('day'::text, (now() - (base.created)::timestamp with time zone)) AS created_days_ago,
    ( SELECT dbconstantbrowsertypes.description
           FROM public.dbconstantbrowsertypes
          WHERE (dbconstantbrowsertypes.id = base.browser)
         LIMIT 1) AS browser_name,
    ( SELECT dbconstantoperatingsystems.description
           FROM public.dbconstantoperatingsystems
          WHERE (dbconstantoperatingsystems.id = base.os)
         LIMIT 1) AS os_name
   FROM public.statlogs base;


ALTER TABLE public.statlogsview OWNER TO filesender;

--
-- Name: trackingevents; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.trackingevents (
    id integer NOT NULL,
    type character varying(16) NOT NULL,
    target_type character varying(255) NOT NULL,
    target_id character varying(255) NOT NULL,
    details text NOT NULL,
    created timestamp without time zone NOT NULL,
    reported timestamp without time zone
);


ALTER TABLE public.trackingevents OWNER TO filesender;

--
-- Name: trackingevents_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.trackingevents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trackingevents_id_seq OWNER TO filesender;

--
-- Name: trackingevents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.trackingevents_id_seq OWNED BY public.trackingevents.id;


--
-- Name: trackingeventsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.trackingeventsview AS
 SELECT trackingevents.id,
    trackingevents.type,
    trackingevents.target_type,
    trackingevents.target_id,
    trackingevents.details,
    trackingevents.created,
    trackingevents.reported,
    date_part('day'::text, (now() - (trackingevents.created)::timestamp with time zone)) AS created_days_ago,
    date_part('day'::text, (now() - (trackingevents.reported)::timestamp with time zone)) AS reported_days_ago
   FROM public.trackingevents;


ALTER TABLE public.trackingeventsview OWNER TO filesender;

--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfers_id_seq OWNER TO filesender;

--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- Name: transfersauditlogsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersauditlogsview AS
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    0 AS fileid,
    a.created AS acreated,
    a.author_type,
    a.author_id,
    a.target_type,
    a.target_id,
    a.event,
    a.id AS aid
   FROM public.transfers t,
    public.auditlogs a
  WHERE (((a.target_id)::text = ((t.id)::character varying(255))::text) AND ((a.target_type)::text = 'Transfer'::text))
UNION
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    0 AS fileid,
    a.created AS acreated,
    a.author_type,
    a.author_id,
    a.target_type,
    a.target_id,
    a.event,
    a.id AS aid
   FROM public.transfers t,
    public.auditlogs a,
    public.files f
  WHERE ((f.transfer_id = t.id) AND ((a.target_id)::text = ((f.id)::character varying(255))::text) AND ((a.target_type)::text = 'File'::text));


ALTER TABLE public.transfersauditlogsview OWNER TO filesender;

--
-- Name: transfersauditlogsdlsubselectcountview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersauditlogsdlsubselectcountview AS
 SELECT transfersauditlogsview.id,
    count(*) AS count
   FROM public.transfersauditlogsview
  WHERE (((transfersauditlogsview.event)::text = 'download_ended'::text) OR ((transfersauditlogsview.event)::text = 'archive_download_ended'::text))
  GROUP BY transfersauditlogsview.id;


ALTER TABLE public.transfersauditlogsdlsubselectcountview OWNER TO filesender;

--
-- Name: transfersauditlogsdlcountview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersauditlogsdlcountview AS
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    zz.count
   FROM (public.transfers t
     LEFT JOIN public.transfersauditlogsdlsubselectcountview zz ON ((t.id = zz.id)));


ALTER TABLE public.transfersauditlogsdlcountview OWNER TO filesender;

--
-- Name: userpreferences; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.userpreferences (
    id bigint NOT NULL,
    authid bigint NOT NULL,
    additional_attributes text,
    lang character varying(8),
    aup_ticked boolean NOT NULL,
    aup_last_ticked_date date,
    transfer_preferences text NOT NULL,
    guest_preferences text NOT NULL,
    frequent_recipients text NOT NULL,
    created timestamp without time zone NOT NULL,
    last_activity timestamp without time zone,
    auth_secret character varying(64),
    auth_secret_created timestamp without time zone,
    quota bigint,
    guest_expiry_default_days integer,
    service_aup_accepted_version integer DEFAULT 0 NOT NULL,
    service_aup_accepted_time timestamp without time zone
);


ALTER TABLE public.userpreferences OWNER TO filesender;

--
-- Name: transfersauthview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersauthview AS
 SELECT t.id,
    t.userid,
    u.authid,
    a.saml_user_identification_uid AS user_id,
    t.made_available,
    t.expires,
    t.created
   FROM public.transfers t,
    public.userpreferences u,
    public.authentications a
  WHERE ((t.userid = u.id) AND (u.authid = a.id));


ALTER TABLE public.transfersauthview OWNER TO filesender;

--
-- Name: transfersfilesview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersfilesview AS
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    f.name AS filename,
    f.size AS filesize
   FROM public.transfers t,
    public.files f
  WHERE (f.transfer_id = t.id);


ALTER TABLE public.transfersfilesview OWNER TO filesender;

--
-- Name: transfersrecipientview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersrecipientview AS
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    r.email AS recipientemail,
    r.id AS recipientid
   FROM public.transfers t,
    public.recipients r
  WHERE (r.transfer_id = t.id);


ALTER TABLE public.transfersrecipientview OWNER TO filesender;

--
-- Name: transferssizeview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transferssizeview AS
SELECT
    NULL::bigint AS id,
    NULL::bigint AS userid,
    NULL::character varying(250) AS user_email,
    NULL::bigint AS guest_id,
    NULL::character varying(8) AS lang,
    NULL::character varying(250) AS subject,
    NULL::text AS message,
    NULL::timestamp without time zone AS created,
    NULL::timestamp without time zone AS made_available,
    NULL::timestamp without time zone AS expires,
    NULL::smallint AS expiry_extensions,
    NULL::character varying(32) AS status,
    NULL::text AS options,
    NULL::smallint AS key_version,
    NULL::character varying(32) AS salt,
    NULL::smallint AS password_version,
    NULL::integer AS password_encoding,
    NULL::bigint AS password_hash_iterations,
    NULL::character varying(44) AS client_entropy,
    NULL::character varying(44) AS roundtriptoken,
    NULL::boolean AS guest_transfer_shown_to_user_who_invited_guest,
    NULL::numeric AS size;


ALTER TABLE public.transferssizeview OWNER TO filesender;

--
-- Name: transfersview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.transfersview AS
 SELECT transfers.id,
    transfers.userid,
    transfers.user_email,
    transfers.guest_id,
    transfers.lang,
    transfers.subject,
    transfers.message,
    transfers.created,
    transfers.made_available,
    transfers.expires,
    transfers.expiry_extensions,
    transfers.status,
    transfers.options,
    transfers.key_version,
    transfers.salt,
    transfers.password_version,
    transfers.password_encoding,
    transfers.password_hash_iterations,
    transfers.client_entropy,
    transfers.roundtriptoken,
    transfers.guest_transfer_shown_to_user_who_invited_guest,
    date_part('day'::text, (now() - (transfers.created)::timestamp with time zone)) AS created_days_ago,
    date_part('day'::text, (now() - (transfers.expires)::timestamp with time zone)) AS expires_days_ago,
    date_part('day'::text, (now() - (transfers.made_available)::timestamp with time zone)) AS made_available_days_ago,
    (transfers.options ~~ '%encryption":true%'::text) AS is_encrypted,
        CASE
            WHEN (transfers.password_version = 1) THEN 'user'::text
            ELSE 'generated'::text
        END AS password_origin
   FROM public.transfers;


ALTER TABLE public.transfersview OWNER TO filesender;

--
-- Name: translatableemails; Type: TABLE; Schema: public; Owner: filesender
--

CREATE TABLE public.translatableemails (
    id integer NOT NULL,
    context_type character varying(255) NOT NULL,
    context_id character varying(255) NOT NULL,
    token character varying(60) NOT NULL,
    translation_id character varying(255) NOT NULL,
    variables text NOT NULL,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.translatableemails OWNER TO filesender;

--
-- Name: translatableemails_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.translatableemails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.translatableemails_id_seq OWNER TO filesender;

--
-- Name: translatableemails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.translatableemails_id_seq OWNED BY public.translatableemails.id;


--
-- Name: translatableemailsview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.translatableemailsview AS
 SELECT translatableemails.id,
    translatableemails.context_type,
    translatableemails.context_id,
    translatableemails.token,
    translatableemails.translation_id,
    translatableemails.variables,
    translatableemails.created,
    date_part('day'::text, (now() - (translatableemails.created)::timestamp with time zone)) AS created_days_ago
   FROM public.translatableemails;


ALTER TABLE public.translatableemailsview OWNER TO filesender;

--
-- Name: userauthview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.userauthview AS
 SELECT up.id,
    up.authid,
    a.saml_user_identification_uid AS user_id,
    up.last_activity,
    up.aup_ticked,
    up.created
   FROM public.userpreferences up,
    public.authentications a
  WHERE (up.authid = a.id);


ALTER TABLE public.userauthview OWNER TO filesender;

--
-- Name: userpreferences_id_seq; Type: SEQUENCE; Schema: public; Owner: filesender
--

CREATE SEQUENCE public.userpreferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userpreferences_id_seq OWNER TO filesender;

--
-- Name: userpreferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: filesender
--

ALTER SEQUENCE public.userpreferences_id_seq OWNED BY public.userpreferences.id;


--
-- Name: userpreferencesview; Type: VIEW; Schema: public; Owner: filesender
--

CREATE VIEW public.userpreferencesview AS
 SELECT userpreferences.id,
    userpreferences.authid,
    userpreferences.additional_attributes,
    userpreferences.lang,
    userpreferences.aup_ticked,
    userpreferences.aup_last_ticked_date,
    userpreferences.transfer_preferences,
    userpreferences.guest_preferences,
    userpreferences.frequent_recipients,
    userpreferences.created,
    userpreferences.last_activity,
    userpreferences.auth_secret,
    userpreferences.auth_secret_created,
    userpreferences.quota,
    userpreferences.guest_expiry_default_days,
    userpreferences.service_aup_accepted_version,
    userpreferences.service_aup_accepted_time,
    date_part('day'::text, (now() - (userpreferences.created)::timestamp with time zone)) AS created_days_ago,
    (userpreferences.transfer_preferences ~~ '%encryption":true%'::text) AS prefers_enceyption,
    date_part('day'::text, (now() - (userpreferences.last_activity)::timestamp with time zone)) AS last_activity_days_ago,
    date_part('day'::text, (now() - (userpreferences.aup_last_ticked_date)::timestamp with time zone)) AS aup_last_ticked_days_ago,
    date_part('day'::text, (now() - (userpreferences.service_aup_accepted_time)::timestamp with time zone)) AS service_aup_accepted_time_days_ago,
    userpreferences.id AS email_address,
    (userpreferences.id IS NOT NULL) AS is_active
   FROM public.userpreferences;


ALTER TABLE public.userpreferencesview OWNER TO filesender;

--
-- Name: auditlogs id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.auditlogs ALTER COLUMN id SET DEFAULT nextval('public.auditlogs_id_seq'::regclass);


--
-- Name: authentications id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.authentications ALTER COLUMN id SET DEFAULT nextval('public.authentications_id_seq'::regclass);


--
-- Name: avresults id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.avresults ALTER COLUMN id SET DEFAULT nextval('public.avresults_id_seq'::regclass);


--
-- Name: clientlogs id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.clientlogs ALTER COLUMN id SET DEFAULT nextval('public.clientlogs_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- Name: dbtestingtablestringnumbers id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbtestingtablestringnumbers ALTER COLUMN id SET DEFAULT nextval('public.dbtestingtablestringnumbers_id_seq'::regclass);


--
-- Name: files id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: guests id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.guests ALTER COLUMN id SET DEFAULT nextval('public.guests_id_seq'::regclass);


--
-- Name: metadatas id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.metadatas ALTER COLUMN id SET DEFAULT nextval('public.metadatas_id_seq'::regclass);


--
-- Name: ratelimithistorys id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.ratelimithistorys ALTER COLUMN id SET DEFAULT nextval('public.ratelimithistorys_id_seq'::regclass);


--
-- Name: recipients id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.recipients ALTER COLUMN id SET DEFAULT nextval('public.recipients_id_seq'::regclass);


--
-- Name: shredfiles id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.shredfiles ALTER COLUMN id SET DEFAULT nextval('public.shredfiles_id_seq'::regclass);


--
-- Name: statlogs id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.statlogs ALTER COLUMN id SET DEFAULT nextval('public.statlogs_id_seq'::regclass);


--
-- Name: trackingevents id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.trackingevents ALTER COLUMN id SET DEFAULT nextval('public.trackingevents_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Name: translatableemails id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.translatableemails ALTER COLUMN id SET DEFAULT nextval('public.translatableemails_id_seq'::regclass);


--
-- Name: userpreferences id; Type: DEFAULT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.userpreferences ALTER COLUMN id SET DEFAULT nextval('public.userpreferences_id_seq'::regclass);


--
-- Data for Name: aggregatestatisticmetadatas; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.aggregatestatisticmetadatas (id, filesenderversion, lastsend) FROM stdin;
1	2.44	2024-06-28 13:54:58
\.


--
-- Data for Name: aggregatestatistics; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.aggregatestatistics (epoch, epochtype, eventtype, eventcount, timesum, sizesum, encryptedsum) FROM stdin;
\.


--
-- Data for Name: auditlogs; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.auditlogs (id, event, target_type, target_id, author_type, author_id, ip, transaction_id, created) FROM stdin;
\.


--
-- Data for Name: authentications; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.authentications (id, saml_user_identification_uid, saml_user_identification_uid_hash, created, last_activity, comment, passwordhash) FROM stdin;
1	filesender-upgrade@localhost.localdomain	eece83dce87f847507180314d6b8136287df6638	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
2	filesender-cronjob@localhost.localdomain	09551aefc9814314a39bca7665b2b6e3f7bb7768	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
3	filesender-authlocal@localhost.localdomain	fc1480ea65924356a16044044011241e417eda18	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
4	filesender-phpunit@localhost.localdomain	1f3d0c70881af2f372047979212d631e34d6942c	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
5	filesender-testdriver@localhost.localdomain	95a3b99f10c24104ccc6a3a885761bd1cdfb5612	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
6	filesender-reserved1@localhost.localdomain	dc422eaa60c2d7f6aa89bb91fb3d5c77d1daefc9	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
7	filesender-reserved2@localhost.localdomain	11d71451001a1929f12c121d8c51490c23b47721	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
8	filesender-reserved3@localhost.localdomain	631bb38331308e068e9761d50636c1dcf142d721	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
9	filesender-reserved4@localhost.localdomain	25fe1ff3e3597518aa26a75e58a6cb8193f798b9	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
10	filesender-reserved5@localhost.localdomain	922b11256bd3cc8eb958914248636e326bbb4a03	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
11	filesender-reserved6@localhost.localdomain	710be4f36b094642ca00abd77d1248b72e63561c	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
12	filesender-reserved7@localhost.localdomain	8f31f04fd084fd30b32fcd9dfb822953db4d884a	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
13	filesender-reserved8@localhost.localdomain	af6c5b4e8a42b675c84ebe2d7d140675fbfec35d	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
14	filesender-reserved9@localhost.localdomain	5db030b8e1853eba8a4ac60f745642dc69a05008	2024-06-28 13:54:58	2024-06-28 13:54:58	\N	\N
\.


--
-- Data for Name: avresults; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.avresults (id, file_id, app_id, name, passes, error, internaldesc, created) FROM stdin;
\.


--
-- Data for Name: clientlogs; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.clientlogs (id, userid, created, message) FROM stdin;
\.


--
-- Data for Name: collections; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.collections (id, transfer_id, parent_id, type_id, info) FROM stdin;
\.


--
-- Data for Name: collectiontypes; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.collectiontypes (id, name, description) FROM stdin;
\.


--
-- Data for Name: dbconstantavprograms; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantavprograms (id, description) FROM stdin;
1	test
2	always_fail
3	always_pass
4	always_error
5	url
6	toobig
7	mime
8	encrypted
\.


--
-- Data for Name: dbconstantbrowsertypes; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantbrowsertypes (id, description) FROM stdin;
0	Unknown
1	Edge
2	Internet Explorer
3	Mozilla Firefox
4	Vivaldi
5	Opera
6	Google Chrome
7	Apple Safari
8	Outlook
\.


--
-- Data for Name: dbconstantepochtypes; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantepochtypes (id, description) FROM stdin;
1	fifteen_minutes
2	hour
3	day
4	week
5	month
6	year
\.


--
-- Data for Name: dbconstantoperatingsystems; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantoperatingsystems (id, description) FROM stdin;
0	Unknown
1	iPad
2	iPod
3	iPhone
4	Mac
5	OSX
6	Android
7	Linux
8	Nokia
9	Windows 10
10	Windows 8.1
11	Windows 8.0
12	Windows 7.0
13	Windows (Other)
14	FreeBSD
15	OpenBSD
16	NetBSD
17	Solaris
18	OS2
19	BEOS
\.


--
-- Data for Name: dbconstantpasswordencodings; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantpasswordencodings (id, description) FROM stdin;
0	none
1	base64
2	ascii85
\.


--
-- Data for Name: dbconstantstatsevents; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbconstantstatsevents (id, description) FROM stdin;
1	upload_started
2	upload_resumed
3	upload_ended
4	user_created
5	user_purged
6	user_inactived
7	download_started
8	download_resumed
9	download_ended
11	upload_maxsize_ended
101	upload_nocrypt_started
102	upload_nocrypt_resumed
103	upload_nocrypt_ended
107	download_nocrypt_started
108	download_nocrypt_resumed
109	download_nocrypt_ended
111	upload_nocrypt_maxsize_ended
201	upload_encrypted_started
202	upload_encrypted_resumed
203	upload_encrypted_ended
207	download_encrypted_started
208	download_encrypted_resumed
209	download_encrypted_ended
211	upload_encrypted_maxsize_ended
501	storage-expired-transfers-size
502	storage-used-size
503	storage-free-size
\.


--
-- Data for Name: dbtestingtablestringnumbers; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.dbtestingtablestringnumbers (id, data, created) FROM stdin;
\.


--
-- Data for Name: downloadonetimepasswords; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.downloadonetimepasswords (tid, rid, created, password, verified) FROM stdin;
\.


--
-- Data for Name: filecollections; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.filecollections (collection_id, file_id) FROM stdin;
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.files (id, transfer_id, uid, name, mime_type, size, encrypted_size, upload_start, upload_end, sha1, storage_class_name, iv, aead, have_avresults) FROM stdin;
\.


--
-- Data for Name: guests; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.guests (id, userid, user_email, token, email, transfer_count, subject, message, options, transfer_options, status, created, expires, last_activity, reminder_count, last_reminder, expiry_extensions, service_aup_accepted_version, service_aup_accepted_time) FROM stdin;
\.


--
-- Data for Name: metadatas; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.metadatas (id, schemaversion, created, message) FROM stdin;
1	22	2024-06-28 13:54:58	running database update script on existing schema version 0
\.


--
-- Data for Name: ratelimithistorys; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.ratelimithistorys (id, created, author_context_type, author_context_id, action, event, target_context_type, target_context_id) FROM stdin;
\.


--
-- Data for Name: recipients; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.recipients (id, transfer_id, email, token, created, last_activity, options, reminder_count, last_reminder) FROM stdin;
\.


--
-- Data for Name: shredfiles; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.shredfiles (id, name, errormessage) FROM stdin;
\.


--
-- Data for Name: statlogs; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.statlogs (id, event, target_type, size, time_taken, additional_attributes, created, browser, os, is_encrypted) FROM stdin;
\.


--
-- Data for Name: trackingevents; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.trackingevents (id, type, target_type, target_id, details, created, reported) FROM stdin;
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.transfers (id, userid, user_email, guest_id, lang, subject, message, created, made_available, expires, expiry_extensions, status, options, key_version, salt, password_version, password_encoding, password_hash_iterations, client_entropy, roundtriptoken, guest_transfer_shown_to_user_who_invited_guest) FROM stdin;
\.


--
-- Data for Name: translatableemails; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.translatableemails (id, context_type, context_id, token, translation_id, variables, created) FROM stdin;
\.


--
-- Data for Name: userpreferences; Type: TABLE DATA; Schema: public; Owner: filesender
--

COPY public.userpreferences (id, authid, additional_attributes, lang, aup_ticked, aup_last_ticked_date, transfer_preferences, guest_preferences, frequent_recipients, created, last_activity, auth_secret, auth_secret_created, quota, guest_expiry_default_days, service_aup_accepted_version, service_aup_accepted_time) FROM stdin;
1	1	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
2	2	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
3	3	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
4	4	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
5	5	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
6	6	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
7	7	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
8	8	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
9	9	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
10	10	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
11	11	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
12	12	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
13	13	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
14	14	\N	\N	f	1970-01-01	null	null	null	2024-06-28 13:54:58	1970-01-01 01:00:00	\N	\N	0	\N	0	\N
\.


--
-- Name: auditlogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.auditlogs_id_seq', 1, false);


--
-- Name: authentications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.authentications_id_seq', 14, true);


--
-- Name: avresults_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.avresults_id_seq', 1, false);


--
-- Name: clientlogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.clientlogs_id_seq', 1, false);


--
-- Name: collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.collections_id_seq', 1, false);


--
-- Name: dbtestingtablestringnumbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.dbtestingtablestringnumbers_id_seq', 1, false);


--
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.files_id_seq', 1, false);


--
-- Name: guests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.guests_id_seq', 1, false);


--
-- Name: metadatas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.metadatas_id_seq', 1, true);


--
-- Name: ratelimithistorys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.ratelimithistorys_id_seq', 1, false);


--
-- Name: recipients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.recipients_id_seq', 1, false);


--
-- Name: shredfiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.shredfiles_id_seq', 1, false);


--
-- Name: statlogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.statlogs_id_seq', 1, false);


--
-- Name: trackingevents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.trackingevents_id_seq', 1, false);


--
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.transfers_id_seq', 1, false);


--
-- Name: translatableemails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.translatableemails_id_seq', 1, false);


--
-- Name: userpreferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: filesender
--

SELECT pg_catalog.setval('public.userpreferences_id_seq', 14, true);


--
-- Name: aggregatestatisticmetadatas aggregatestatisticmetadatas_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.aggregatestatisticmetadatas
    ADD CONSTRAINT aggregatestatisticmetadatas_pkey PRIMARY KEY (id);


--
-- Name: aggregatestatistics aggregatestatistics_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.aggregatestatistics
    ADD CONSTRAINT aggregatestatistics_pkey PRIMARY KEY (epoch, epochtype, eventtype);


--
-- Name: auditlogs auditlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.auditlogs
    ADD CONSTRAINT auditlogs_pkey PRIMARY KEY (id);


--
-- Name: authentications authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: avresults avresults_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.avresults
    ADD CONSTRAINT avresults_pkey PRIMARY KEY (id, file_id, app_id, created);


--
-- Name: clientlogs clientlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.clientlogs
    ADD CONSTRAINT clientlogs_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: collectiontypes collectiontypes_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.collectiontypes
    ADD CONSTRAINT collectiontypes_pkey PRIMARY KEY (id);


--
-- Name: dbconstantavprograms dbconstantavprograms_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantavprograms
    ADD CONSTRAINT dbconstantavprograms_pkey PRIMARY KEY (id);


--
-- Name: dbconstantbrowsertypes dbconstantbrowsertypes_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantbrowsertypes
    ADD CONSTRAINT dbconstantbrowsertypes_pkey PRIMARY KEY (id);


--
-- Name: dbconstantepochtypes dbconstantepochtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantepochtypes
    ADD CONSTRAINT dbconstantepochtypes_pkey PRIMARY KEY (id);


--
-- Name: dbconstantoperatingsystems dbconstantoperatingsystems_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantoperatingsystems
    ADD CONSTRAINT dbconstantoperatingsystems_pkey PRIMARY KEY (id);


--
-- Name: dbconstantpasswordencodings dbconstantpasswordencodings_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantpasswordencodings
    ADD CONSTRAINT dbconstantpasswordencodings_pkey PRIMARY KEY (id);


--
-- Name: dbconstantstatsevents dbconstantstatsevents_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbconstantstatsevents
    ADD CONSTRAINT dbconstantstatsevents_pkey PRIMARY KEY (id);


--
-- Name: dbtestingtablestringnumbers dbtestingtablestringnumbers_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.dbtestingtablestringnumbers
    ADD CONSTRAINT dbtestingtablestringnumbers_pkey PRIMARY KEY (id);


--
-- Name: downloadonetimepasswords downloadonetimepasswords_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.downloadonetimepasswords
    ADD CONSTRAINT downloadonetimepasswords_pkey PRIMARY KEY (tid, rid, created);


--
-- Name: filecollections filecollections_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.filecollections
    ADD CONSTRAINT filecollections_pkey PRIMARY KEY (collection_id, file_id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: guests guests_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_pkey PRIMARY KEY (id);


--
-- Name: guests guests_token_key; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_token_key UNIQUE (token);


--
-- Name: metadatas metadatas_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.metadatas
    ADD CONSTRAINT metadatas_pkey PRIMARY KEY (id);


--
-- Name: ratelimithistorys ratelimithistorys_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.ratelimithistorys
    ADD CONSTRAINT ratelimithistorys_pkey PRIMARY KEY (id);


--
-- Name: recipients recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT recipients_pkey PRIMARY KEY (id);


--
-- Name: shredfiles shredfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.shredfiles
    ADD CONSTRAINT shredfiles_pkey PRIMARY KEY (id);


--
-- Name: statlogs statlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.statlogs
    ADD CONSTRAINT statlogs_pkey PRIMARY KEY (id);


--
-- Name: trackingevents trackingevents_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.trackingevents
    ADD CONSTRAINT trackingevents_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: translatableemails translatableemails_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.translatableemails
    ADD CONSTRAINT translatableemails_pkey PRIMARY KEY (id);


--
-- Name: userpreferences userpreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT userpreferences_pkey PRIMARY KEY (id);


--
-- Name: auditlogs_author_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX auditlogs_author_id ON public.auditlogs USING btree (author_type, author_id);


--
-- Name: auditlogs_created; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX auditlogs_created ON public.auditlogs USING btree (created);


--
-- Name: auditlogs_created_event_ttype_tid; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX auditlogs_created_event_ttype_tid ON public.auditlogs USING btree (created, event, target_type, target_id);


--
-- Name: auditlogs_transaction_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX auditlogs_transaction_id ON public.auditlogs USING btree (transaction_id);


--
-- Name: auditlogs_type_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX auditlogs_type_id ON public.auditlogs USING btree (target_type, target_id);


--
-- Name: authentications_saml_user_identification_uid; Type: INDEX; Schema: public; Owner: filesender
--

CREATE UNIQUE INDEX authentications_saml_user_identification_uid ON public.authentications USING btree (saml_user_identification_uid);


--
-- Name: authentications_saml_user_identification_uid_hash; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX authentications_saml_user_identification_uid_hash ON public.authentications USING btree (saml_user_identification_uid_hash);


--
-- Name: clientlogs_created_and_userid; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX clientlogs_created_and_userid ON public.clientlogs USING btree (created, userid);


--
-- Name: clientlogs_userid; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX clientlogs_userid ON public.clientlogs USING btree (userid);


--
-- Name: collections_parent_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX collections_parent_id ON public.collections USING btree (parent_id);


--
-- Name: collections_transfer_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX collections_transfer_id ON public.collections USING btree (transfer_id);


--
-- Name: collections_type_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX collections_type_id ON public.collections USING btree (type_id);


--
-- Name: dbconstantavprograms_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantavprograms_description ON public.dbconstantavprograms USING btree (description);


--
-- Name: dbconstantbrowsertypes_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantbrowsertypes_description ON public.dbconstantbrowsertypes USING btree (description);


--
-- Name: dbconstantepochtypes_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantepochtypes_description ON public.dbconstantepochtypes USING btree (description);


--
-- Name: dbconstantoperatingsystems_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantoperatingsystems_description ON public.dbconstantoperatingsystems USING btree (description);


--
-- Name: dbconstantpasswordencodings_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantpasswordencodings_description ON public.dbconstantpasswordencodings USING btree (description);


--
-- Name: dbconstantstatsevents_description; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbconstantstatsevents_description ON public.dbconstantstatsevents USING btree (description);


--
-- Name: dbtestingtablestringnumbers_dataidx; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX dbtestingtablestringnumbers_dataidx ON public.dbtestingtablestringnumbers USING btree (data);


--
-- Name: filecollections_file_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX filecollections_file_id ON public.filecollections USING btree (file_id);


--
-- Name: files_transfer_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX files_transfer_id ON public.files USING btree (transfer_id);


--
-- Name: ratelimithistorys_action_event_created; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX ratelimithistorys_action_event_created ON public.ratelimithistorys USING btree (action, event, created);


--
-- Name: recipients_token; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX recipients_token ON public.recipients USING btree (token);


--
-- Name: statlogs_created; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX statlogs_created ON public.statlogs USING btree (created);


--
-- Name: statlogs_event_tt; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX statlogs_event_tt ON public.statlogs USING btree (event, target_type);


--
-- Name: trackingevents_type_id; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX trackingevents_type_id ON public.trackingevents USING btree (target_type, id);


--
-- Name: transfers_expires; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX transfers_expires ON public.transfers USING btree (expires);


--
-- Name: transfers_user_email; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX transfers_user_email ON public.transfers USING btree (user_email);


--
-- Name: transfers_userid; Type: INDEX; Schema: public; Owner: filesender
--

CREATE INDEX transfers_userid ON public.transfers USING btree (userid);


--
-- Name: transferssizeview _RETURN; Type: RULE; Schema: public; Owner: filesender
--

CREATE OR REPLACE VIEW public.transferssizeview AS
 SELECT t.id,
    t.userid,
    t.user_email,
    t.guest_id,
    t.lang,
    t.subject,
    t.message,
    t.created,
    t.made_available,
    t.expires,
    t.expiry_extensions,
    t.status,
    t.options,
    t.key_version,
    t.salt,
    t.password_version,
    t.password_encoding,
    t.password_hash_iterations,
    t.client_entropy,
    t.roundtriptoken,
    t.guest_transfer_shown_to_user_who_invited_guest,
    sum(f.size) AS size
   FROM public.transfers t,
    public.files f
  WHERE (f.transfer_id = t.id)
  GROUP BY t.id;


--
-- Name: aggregatestatistics aggregatestatistic_epochtype; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.aggregatestatistics
    ADD CONSTRAINT aggregatestatistic_epochtype FOREIGN KEY (epochtype) REFERENCES public.dbconstantepochtypes(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: aggregatestatistics aggregatestatistic_eventtype; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.aggregatestatistics
    ADD CONSTRAINT aggregatestatistic_eventtype FOREIGN KEY (eventtype) REFERENCES public.dbconstantstatsevents(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: clientlogs clientlog_userid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.clientlogs
    ADD CONSTRAINT clientlog_userid FOREIGN KEY (userid) REFERENCES public.userpreferences(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: downloadonetimepasswords downloadonetimepassword_rid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.downloadonetimepasswords
    ADD CONSTRAINT downloadonetimepassword_rid FOREIGN KEY (rid) REFERENCES public.recipients(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: downloadonetimepasswords downloadonetimepassword_tid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.downloadonetimepasswords
    ADD CONSTRAINT downloadonetimepassword_tid FOREIGN KEY (tid) REFERENCES public.transfers(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: guests guests_userid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_userid FOREIGN KEY (userid) REFERENCES public.userpreferences(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: statlogs statlogs_browsertype; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.statlogs
    ADD CONSTRAINT statlogs_browsertype FOREIGN KEY (browser) REFERENCES public.dbconstantbrowsertypes(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: statlogs statlogs_operatingsystem; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.statlogs
    ADD CONSTRAINT statlogs_operatingsystem FOREIGN KEY (os) REFERENCES public.dbconstantoperatingsystems(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: transfers transfer_passwordencoding; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfer_passwordencoding FOREIGN KEY (password_encoding) REFERENCES public.dbconstantpasswordencodings(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: transfers transfers_userid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_userid FOREIGN KEY (userid) REFERENCES public.userpreferences(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: userpreferences userpreferences_authid; Type: FK CONSTRAINT; Schema: public; Owner: filesender
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT userpreferences_authid FOREIGN KEY (authid) REFERENCES public.authentications(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--
