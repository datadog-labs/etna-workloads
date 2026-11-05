D=$PWD/extdir_tmp
rm -rf $D; mkdir -p $D/extension
cat > $D/extension/xs.control <<'E2'
comment = 'x'
default_version = '1.0'
relocatable = false
E2
echo 'SELECT 1 AS @extschema@;' > $D/extension/xs--1.0.sql
psql -X -a -q <<E2
CREATE SCHEMA "has\$dollar";
SET extension_control_path = '$D:\$system';
CREATE EXTENSION xs SCHEMA "has\$dollar";
SELECT count(*) FROM pg_extension WHERE extname='xs';
E2
rm -rf $D
