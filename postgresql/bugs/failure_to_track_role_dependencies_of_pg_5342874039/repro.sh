D=$PWD/extdir_tmp
mkdir -p $D/extension
cat > $D/extension/rx.control <<E2
default_version = '1.0'
relocatable = true
E2
cat > $D/extension/rx--1.0.sql <<'E2'
CREATE TABLE rx_t(a int);
GRANT SELECT ON rx_t TO regress_rx_role;
E2
psql -X -a -q <<E2
CREATE ROLE regress_rx_role;
SET extension_control_path = '$D:\$system';
CREATE EXTENSION rx;
SELECT deptype FROM pg_shdepend d JOIN pg_roles r ON r.oid=d.refobjid
 WHERE r.rolname='regress_rx_role' ORDER BY 1;
DROP ROLE regress_rx_role;
DROP OWNED BY regress_rx_role;
DROP ROLE regress_rx_role;
E2
rm -rf $D
