CREATE ACCESS METHOD gist2 TYPE INDEX HANDLER gisthandler;
CREATE OPERATOR FAMILY fam2 USING gist2;
SELECT count(*) FROM pg_depend d JOIN pg_opfamily f ON d.objid=f.oid
 WHERE d.classid='pg_opfamily'::regclass AND f.opfname='fam2' AND d.refclassid='pg_am'::regclass;
DROP ACCESS METHOD gist2;
DROP ACCESS METHOD gist2 CASCADE;
