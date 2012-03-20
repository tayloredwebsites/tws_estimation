-- Table: component_types

-- DROP TABLE component_types;

CREATE TABLE component_types
(
  id integer NOT NULL DEFAULT nextval('component_types_seq'::regclass),
  description character varying(255) NOT NULL DEFAULT ''::character varying,
  sort_order integer NOT NULL DEFAULT 0,
  has_costs boolean NOT NULL DEFAULT true,
  has_hours boolean NOT NULL DEFAULT false,
  has_vendor boolean NOT NULL DEFAULT false,
  has_misc boolean NOT NULL DEFAULT false,
  no_entry boolean NOT NULL DEFAULT false,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT now(),
  deactivated boolean NOT NULL DEFAULT false,
  CONSTRAINT component_types_pk_component_types PRIMARY KEY (id),
  CONSTRAINT component_types_ix_component_types_description UNIQUE (description),
  CONSTRAINT components_ix_components UNIQUE (id, description)
)
WITH (
  OIDS=FALSE
);

