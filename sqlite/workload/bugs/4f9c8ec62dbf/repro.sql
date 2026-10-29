PRAGMA page_size=16384;
CREATE TABLE t1(x);
PRAGMA cache_size=2;
PRAGMA cache_spill(-51);
PRAGMA cache_spill;
