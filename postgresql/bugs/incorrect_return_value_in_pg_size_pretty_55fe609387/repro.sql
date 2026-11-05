SELECT s, pg_size_pretty(s), pg_size_pretty(-s) FROM (VALUES (10239::bigint),(10240),(10485247),(10485248),(10736893951),(10736893952),(11258449312612351)) x(s);
