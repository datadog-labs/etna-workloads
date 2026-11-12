.mode list
.nullvalue NULL
SET debug_verify_column_bindings = true;
CREATE TABLE v(id INTEGER PRIMARY KEY);
INSERT INTO v VALUES (1), (2), (3), (4);
SET disabled_optimizers = '';
PRAGMA explain_output='optimized_only';
EXPLAIN SELECT b.value
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
PRAGMA explain_output='physical_only';
EXPLAIN SELECT b.value
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
SELECT b.value
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
SELECT b.unused_payload
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value, b.unused_payload
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
SELECT b.unused_payload.id
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value, b.unused_payload
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
SET disabled_optimizers = 'join_order,build_side_probe_side';
PRAGMA explain_output='optimized_only';
EXPLAIN SELECT b.value
FROM (SELECT id AS k, 0 AS domain FROM v) a
JOIN LATERAL (
    WITH t AS MATERIALIZED (SELECT a.k AS n)
    SELECT n FROM t
) q ON true
JOIN (
    SELECT b.k, b.domain, b.value
    FROM (
        SELECT id AS k, 0 AS domain,
               struct_pack(id := id) AS unused_payload,
               id AS value
        FROM v
    ) b
) b ON b.k = q.n AND b.domain IS NOT DISTINCT FROM a.domain
WHERE a.k = 1;
