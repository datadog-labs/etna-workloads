SELECT 'wa:1D wb:2A'::tsvector @@ 'w:*D <-> w:*A'::tsquery as "true";
SELECT to_tsvector('simple', '1 2 11 3') @@ '1:* <-> 3' AS "true";
