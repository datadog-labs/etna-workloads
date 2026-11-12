SELECT octet_length(ST_AsWKB(g)) FROM (SELECT ST_GeomFromWKB(x) AS g FROM (VALUES (''::BLOB)) t(x));
