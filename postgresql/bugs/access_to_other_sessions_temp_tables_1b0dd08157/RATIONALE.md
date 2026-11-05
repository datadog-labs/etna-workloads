# Rationale
Restores the pre-fix state: the other-session temp check lives only in ReadBufferExtended() (and PrefetchBuffer()); read_stream and StartReadBuffersImpl paths are unchecked.

Hunks (all trace to fix_impl.patch hunks, reversed):
- src/backend/storage/aio/read_stream.c, read_stream_begin_impl(): removed the RELATION_IS_OTHER_TEMP check (read_stream.c hunk). Seq scans via read streams no longer error.
- src/backend/storage/buffer/bufmgr.c, ReadBufferExtended(): re-added the check removed by the fix hunk (and restored the comment).
- bufmgr.c, ReadBuffer_common(): removed the check added by the fix.
- bufmgr.c, StartReadBuffersImpl(): removed the check added by the fix.
(Comment-only hunks in rel.h / PrefetchBuffer left untouched.)

Failing oracle cases: COPY, DELETE, MERGE, SELECT (seqscan via read_stream), UPDATE.
