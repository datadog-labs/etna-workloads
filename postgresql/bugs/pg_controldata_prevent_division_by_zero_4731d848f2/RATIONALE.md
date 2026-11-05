# Rationale

File: src/bin/pg_controldata/pg_controldata.c, function main().
Traces to the fix.patch hunk that wraps the XLByteToSeg/XLogFileName calls in a `WalSegSz` guard (and moves `segno` into that block).
Reverted: the guard and the "???" fallback are removed, and `segno` is declared at function scope again. XLByteToSeg now divides by WalSegSz unconditionally, so a corrupt control file with xlog_seg_size = 0 causes a division by zero (SIGFPE).

Failing oracle cases: 
All in src/bin/pg_controldata|t/001_pg_controldata.pl:
- pg_controldata with corrupted pg_control status
- pg_controldata with corrupted pg_control stderr /warning: calculated CRC checksum does not match.../
- pg_controldata with corrupted pg_control stderr /warning: invalid WAL segment size/
- pg_controldata with corrupted pg_control stdout /./
(The program crashes with SIGFPE on the zeroed segment size.)
