create table test_pk_constraint(COLUMN_NAME TEXT NOT NULL, constraint COLUMN_NAME_PK primary key (COLUMN_NAME));
create table test_unique_constraint(cOlUmn_name TEXT NOT NULL, unique(COLUMN_NAME));
select 1;
set datafusion.sql_parser.enable_ident_normalization = false;
create table t3(column_name TEXT NOT NULL, constraint COLUMN_NAME_PK primary key (COLUMN_NAME));
