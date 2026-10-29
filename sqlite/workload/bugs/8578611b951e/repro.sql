CREATE VIRTUAL TABLE t1 USING fts3(content);
INSERT INTO t1 VALUES('alpha a b c d e f g h i j k l m n o p q r s beta');
SELECT docid FROM t1 WHERE content MATCH 'alpha NEAR/19 beta';
SELECT docid FROM t1 WHERE content MATCH 'alpha NEAR/000019 beta';
