D=$PWD/ext_tmp_dir
mkdir -p $D/extension
cat > $D/extension/rx.control <<'E2'
comment = 'x'
default_version = '1.0'
relocatable = true
E2
cat > $D/extension/rx--1.0.sql <<'E2'
CREATE OR REPLACE FUNCTION rx_func() RETURNS text AS $$ SELECT 'from extension'::text $$ LANGUAGE sql;
E2
psql -X -a -q <<E2
SET extension_control_path = '$D:\$system';
CREATE FUNCTION rx_func() RETURNS text AS \$\$ SELECT 'original'::text \$\$ LANGUAGE sql;
CREATE EXTENSION rx;
SELECT rx_func();
E2
rm -rf $D
