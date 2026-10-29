CREATE TABLE t(c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17);
CREATE INDEX tc0 ON t(c0);
CREATE INDEX tc1 ON t(c1);
CREATE INDEX tc2 ON t(c2);
CREATE INDEX tc3 ON t(c3);
CREATE INDEX tc4 ON t(c4);
CREATE INDEX tc5 ON t(c5);
CREATE INDEX tc6 ON t(c6);
CREATE INDEX tc7 ON t(c7);
CREATE INDEX tc8 ON t(c8);
CREATE INDEX tc9 ON t(c9);
CREATE INDEX tc10 ON t(c10);
CREATE INDEX tc11 ON t(c11);
CREATE INDEX tc12 ON t(c12);
CREATE INDEX tc13 ON t(c13);
CREATE INDEX tc14 ON t(c14);
CREATE INDEX tc15 ON t(c15);
CREATE INDEX tc16 ON t(c16);
CREATE INDEX tc17 ON t(c17);
INSERT INTO t(c0, c16) VALUES (1,1);
SELECT * FROM t WHERE
  c0=1 or  c1=1 or  c2=1 or  c3=1 or
  c4=1 or  c5=1 or  c6=1 or  c7=1 or
  c8=1 or  c9=1 or c10=1 or c11=1 or
  c12=1 or c13=1 or c14=1 or c15=1 or
  c16=1 or c17=1;
