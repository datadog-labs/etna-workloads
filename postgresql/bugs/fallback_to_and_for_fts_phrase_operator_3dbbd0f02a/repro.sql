select strip(to_tsvector('simple','a b')) @@ to_tsquery('simple','a <-> b');
select strip(to_tsvector('simple','b a')) @@ to_tsquery('simple','a <-> b');
