.mode list
.nullvalue NULL
SELECT count(*), min(i), max(i) FROM range(72057594037927930, 72057594037928236) t(i) WHERE (i::BIGINT::BIGNUM)::VARCHAR <> i::VARCHAR;
