D=$PWD/ext_tmp; rm -rf $D; mkdir -p $D/extension
cat > $D/extension/myext.control <<C
default_version = '1.0'
relocatable = true
C
cat > $D/extension/myext--1.0.sql <<C
CREATE TABLE myext_cfg (a int);
SELECT pg_catalog.pg_extension_config_dump('myext_cfg', '');
C
export PGOPTIONS="-c extension_control_path=$D:\$system"
psql -X -q -c "CREATE EXTENSION myext" -c "INSERT INTO myext_cfg VALUES (42)"
pg_dump --extension=plpgsql postgres | grep -E 'myext_cfg|^42'
echo done
rm -rf $D
