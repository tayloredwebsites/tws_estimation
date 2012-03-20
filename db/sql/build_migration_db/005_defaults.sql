-- Table: "defaults"

-- DROP TABLE "defaults";

CREATE TABLE "defaults"
(
  id integer NOT NULL,
  store character varying(255) NOT NULL DEFAULT ''::character(1),
  "name" character varying(255) NOT NULL DEFAULT ''::character(1),
  "value" numeric(19,4) NOT NULL,
  CONSTRAINT defaults_pk_defaults PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

