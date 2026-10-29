.dbconfig defensive off
PRAGMA page_size=1024;
CREATE VIRTUAL TABLE t1 USING fts5(a, b, c);
INSERT INTO t1 VALUES(
  'hello',
  'alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu',
  'ant bear cat dog elephant fox gorilla hippo iguana jaguar kangaroo lion monkey newt octopus panda quail rabbit snake turtle unicorn vulture walrus xerus yak zebra'
);
UPDATE t1_data SET block = unhex(
  hex(substr(block, 1, 169))
  || replace(hex(zeroblob(448)), '00', 'FF')
  || hex(substr(block, 618, 16))
  || replace(hex(zeroblob(37)), '00', 'FF')
) WHERE id = 137438953473;
SELECT * FROM t1 WHERE t1 MATCH '{a b}: hello';
