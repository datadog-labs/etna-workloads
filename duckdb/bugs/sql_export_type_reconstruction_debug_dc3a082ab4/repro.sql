CREATE TYPE empty_enum AS ENUM ();
PRAGMA disable_optimizer;
EXPLAIN (SQL) SELECT NULL::empty_enum;
