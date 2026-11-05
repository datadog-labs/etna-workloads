D=$PWD/repro_ext_tmp
rm -rf $D; mkdir -p $D/extension
cat > $D/extension/rlsx.control <<EOT
comment = 'x'
default_version = '1.0'
relocatable = true
EOT
cat > $D/extension/rlsx--1.0.sql <<EOT
CREATE TABLE rlsx_tab(a int);
EOT
psql -X -q -c "ALTER SYSTEM SET extension_control_path = '$D:\$system'" -c "select pg_reload_conf()" >/dev/null
sleep 1
psql -X -q <<EOT
CREATE EXTENSION rlsx;
ALTER TABLE rlsx_tab ENABLE ROW LEVEL SECURITY;
CREATE POLICY p1 ON rlsx_tab USING (a > 0);
EOT
pg_dump -s postgres | grep -i -E "policy|row level"
rm -rf $D
