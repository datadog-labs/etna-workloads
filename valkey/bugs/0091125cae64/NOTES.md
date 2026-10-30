LPOS on a non-existent key. The bug swaps lookupKeyRead for lookupKeyWriteOrReply(c, key, NULL)
in lposCommand. On the clean build the reply is nil and the server stays up. On the buggy
build the server segfaults on that LPOS, so the following PING fails to connect.
