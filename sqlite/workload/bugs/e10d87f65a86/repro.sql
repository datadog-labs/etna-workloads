.dbconfig fts3_tokenizer on
SELECT fts3_tokenizer(NULL);
SELECT fts3_tokenizer(NULL, X'1234567812345678');
SELECT fts3_tokenizer(NULL, X'12345678');
