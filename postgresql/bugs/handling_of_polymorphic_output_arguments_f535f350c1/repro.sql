CREATE PROCEDURE ptest6a(inout a anyelement, out b anyelement)
LANGUAGE SQL AS $$ SELECT $1, $1; $$;
CALL ptest6a(1, null);
CALL ptest6a(1.1, null);
