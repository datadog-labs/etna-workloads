SELECT indexrelid::regclass, opcname
FROM (SELECT indexrelid, indrelid, unnest(indkey) as ikey,
             unnest(indclass) as iclass
      FROM pg_index WHERE indrelid < 16384) ss,
      pg_attribute a, pg_opclass opc
WHERE a.attrelid = indrelid AND a.attnum = ikey AND opc.oid = iclass AND
      opcintype != atttypid AND opcname IN ('text_ops','varchar_pattern_ops','text_pattern_ops')
ORDER BY 1;
SELECT indexrelid::regclass, opcname FROM pg_index i, pg_opclass o
WHERE indrelid IN ('pg_seclabel'::regclass,'pg_shseclabel'::regclass) AND o.oid = ANY(indclass::oid[]) AND opcname LIKE 'text%' ORDER BY 1;
