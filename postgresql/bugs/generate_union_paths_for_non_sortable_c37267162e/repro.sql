set enable_hashagg=off;
explain (costs off) select '123'::xid union select '123'::xid;
