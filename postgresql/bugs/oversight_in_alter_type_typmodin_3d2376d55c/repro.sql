CREATE TYPE myvarchar;
CREATE FUNCTION myvarcharin(cstring, oid, integer) RETURNS myvarchar LANGUAGE internal STABLE PARALLEL SAFE AS 'varcharin';
CREATE FUNCTION myvarcharout(myvarchar) RETURNS cstring LANGUAGE internal STABLE PARALLEL SAFE AS 'varcharout';
CREATE TYPE myvarchar (input = myvarcharin, output = myvarcharout, alignment = integer, storage = main);
ALTER TYPE myvarchar SET (receive = -);
ALTER TYPE myvarchar SET (typmod_in = varchartypmodin, typmod_out = varchartypmodout);
SELECT typmodin, typmodout FROM pg_type WHERE typname = '_myvarchar';
