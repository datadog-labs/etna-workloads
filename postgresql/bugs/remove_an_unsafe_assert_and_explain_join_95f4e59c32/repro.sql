analyze pg_enum;
explain (costs off)
select anname, outname, enumtypid
from
  (select pa.proname as anname, coalesce(po.proname, typname) as outname
   from pg_type t
     left join pg_proc po on po.oid = t.typoutput
     join pg_proc pa on pa.oid = t.typanalyze) ss,
  pg_enum,
  pg_type t2
where anname = enumlabel and outname = t2.typname and enumtypid = t2.oid;
