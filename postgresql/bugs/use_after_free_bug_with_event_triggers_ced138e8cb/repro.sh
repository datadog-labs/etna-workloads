D=$PWD/extdir/extension
mkdir -p $D
cat > $D/ev.control <<E2
default_version = '1.0'
relocatable = true
E2
cat > $D/ev--1.0.sql <<'E2'
CREATE TABLE t (id text);
CREATE FUNCTION _evt() RETURNS EVENT_TRIGGER LANGUAGE plpgsql AS $$ BEGIN END; $$;
CREATE EVENT TRIGGER table_rewrite_trg ON table_rewrite EXECUTE PROCEDURE _evt();
E2
cat > $D/ev--1.0--2.0.sql <<'E2'
ALTER EVENT TRIGGER table_rewrite_trg DISABLE;
ALTER TABLE t DROP COLUMN id;
E2
psql -X -a -q <<E2
SET extension_control_path = '$PWD/extdir:\$system';
CREATE EXTENSION ev;
ALTER EXTENSION ev UPDATE TO '2.0';
DROP EXTENSION ev;
E2
