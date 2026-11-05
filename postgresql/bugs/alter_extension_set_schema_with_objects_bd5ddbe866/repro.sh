D=$PWD/extdir_tmp
mkdir -p $D/extension
cat > $D/extension/rx.control <<'X'
comment = 'rx'
default_version = '1.0'
relocatable = true
X
cat > $D/extension/rx--1.0.sql <<'X'
CREATE FUNCTION dep_req1() RETURNS int LANGUAGE sql AS 'SELECT 1';
X
psql -X -a -q <<X 2>&1
SET extension_control_path = '$D:\$system';
CREATE SCHEMA s1; CREATE SCHEMA s2; CREATE SCHEMA s3;
CREATE EXTENSION rx SCHEMA s1;
ALTER FUNCTION s1.dep_req1() SET SCHEMA s2;
ALTER EXTENSION rx SET SCHEMA s3;
SELECT nspname FROM pg_extension e JOIN pg_namespace n ON n.oid=extnamespace WHERE extname='rx';
X
rm -rf $D
