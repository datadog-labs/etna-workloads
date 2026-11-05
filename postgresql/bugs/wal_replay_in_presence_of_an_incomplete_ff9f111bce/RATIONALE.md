# Rationale

## src/src/backend/access/transam/xlogreader.c, XLogReadRecord()
Traces to the fix.patch hunk in XLogReadRecord that added the check
`if (pageHeader->xlp_info & XLP_FIRST_IS_OVERWRITE_CONTRECORD) { overwrittenRecPtr = ...; RecPtr = targetPagePtr; goto restart; }`.
I removed that block. When a continuation page carries the overwrite-contrecord flag, the reader no longer
discards the partial record and restarts at that page. It treats the page as a bad continuation, so replay stops
at the incomplete record and a standby cannot replay past the overwritten contrecord.

Oracle cases that fail: "found log line in standby" and "standby replays past overwritten contrecord" (026_overwrite_contrecord.pl). "<N> differs from <N>" still passes.
