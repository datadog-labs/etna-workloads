d=$PWD/extrepro_dir
mkdir -p $d/extension
cat > $d/extension/ess.control <<E2
comment = 'x'
default_version = '1.0'
relocatable = true
E2
cat > $d/extension/ess--1.0.sql <<E2
CREATE TABLE ess_table (f1 int primary key, f2 int, f3 text);
CREATE TYPE ess_range_type AS RANGE (subtype = text);
CREATE TYPE ess_composite_type AS (f1 int, f2 ess_range_type);
E2
psql -X -a -q <<E2
SET extension_control_path = '$d:\$system';
CREATE SCHEMA s1;
CREATE SCHEMA s2;
CREATE EXTENSION ess SCHEMA s1;
ALTER EXTENSION ess SET SCHEMA s2;
SELECT count(*) FROM pg_type t JOIN pg_namespace n ON n.oid=typnamespace WHERE nspname='s2' AND typname LIKE 'ess%';
E2
rm -rf $d
