# Rationale

File: src/src/backend/utils/adt/xml.c, function pg_xml_init.
Traces to the fix_impl.patch hunk in pg_xml_init that adds
`xmlSetExternalEntityLoader(xmlPgEntityLoader);`. I removed that call, so the
safe entity loader is never installed and libxml2 can again fetch external
files/URLs via XML entity references. The loader function and the
save/restore code are left in place (the loader is now unused).

Failing oracle case: src/test/regress||xml
