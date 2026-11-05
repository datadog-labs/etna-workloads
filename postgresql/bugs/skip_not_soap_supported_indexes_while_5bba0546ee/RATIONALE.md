Changes in src/backend/optimizer/path/indxpath.c (both hunks trace to the two hunks of fix_impl.patch):

1. group_similar_or_args(): the index-skip condition goes back to `!index->amhasgetbitmap`. The `|| !index->amsearcharray` check is removed. Indexes that cannot do SAOP are no longer skipped when OR arguments are grouped.
2. match_orclause_to_indexcol(): the early `if (!index->amsearcharray) return NULL;` is removed. An OR clause is therefore transformed into a SAOP for indexes without amsearcharray support.

Failing oracle case: src/test/regress||create_index
