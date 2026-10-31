Writes a PAX tar whose "11 foo=bar\n" record is replaced with malformed records
(bad/zero/negative/oversized length, empty keyword, ...) and reopens it with tarfile.
Clean: every case raises ReadError('invalid header'). Buggy (old regex-based pax
parser without framing checks): several cases give 'bad checksum' or are mis-parsed instead.
