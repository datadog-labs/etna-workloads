Sends MULTI / AUTH no-user foobar / EXEC on one connection. Clean: EXEC returns the WRONGPASS error for AUTH.
Buggy: addAuthErrReply sees the pending reply (the +QUEUED) and skips adding the error, so the EXEC result is missing/mismatched.
