SELECT ts_rank_cd(strip(to_tsvector('both stripped')), to_tsquery('both & stripped'));
SELECT ts_rank_cd(to_tsvector('unstripped') || strip(to_tsvector('stripped')), to_tsquery('unstripped & stripped'));
