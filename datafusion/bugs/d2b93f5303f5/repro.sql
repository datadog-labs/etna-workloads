SET datafusion.execution.target_partitions = 4;
SET datafusion.execution.batch_size = 8192;

WITH typ(oid, typnamespace, typname, typtype) AS (
                    SELECT * FROM (VALUES (1, 10, 't1', 'b'))
          UNION ALL SELECT * FROM (VALUES (2, NULL, 't2', 'b'))
          UNION ALL SELECT * FROM (VALUES (3, 12, 't3', NULL))
          UNION ALL SELECT * FROM (VALUES (4, 40, 't3', 'm'))
     ), ns(oid, nspname) AS (
       VALUES (1, 'ns1'), (2, 'ns2'), (40, 'ns3')
     )
  SELECT ns.nspname, typ.oid, typ.typname, typ.typtype
    FROM typ JOIN ns ON (ns.oid = typ.typnamespace)
   WHERE typ.typtype IN ('b','r','m','e','d')
   ORDER BY CASE WHEN typ.typtype IN ('b','e','p') THEN 0
                 WHEN typ.typtype = 'r' THEN 1
            END;
