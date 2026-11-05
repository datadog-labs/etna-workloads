# Rationale

## src/backend/access/transam/xlogreader.c, XLogReadRecord()
Traces to the fix.patch hunk that replaced `!nonblocking /* allow_oversized */` with
`false /* allow_oversized */` for the first XLogReadRecordAlloc() call, so that xl_tot_len is
not trusted before the header has been validated. I restored `!nonblocking`. Now an unvalidated
xl_tot_len (e.g. garbage from a recycled WAL page) is used to palloc a decode buffer before
validation. An absurd length hits a hard allocation error instead of a clean "invalid record"
end-of-WAL condition.

Only this one line was changed. The rest of the fix (the deferred allocation code and the
readRecordBuf growth after validation) is left as is, because it is harmless without this line.

## Failing oracle cases (9/14)
xlp_info bad, xlp_info lacks XLP_FIRST_IS_CONTRECORD, xlp_magic bad, xlp_magic zero,
xlp_magic zero (split record header), xlp_pageaddr bad, xlp_pageaddr bad (split record header),
xlp_rem_len bad, xlp_rem_len bad (split record header).
