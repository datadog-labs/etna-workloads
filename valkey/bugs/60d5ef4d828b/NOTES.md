repro.sh sends EVALSHA with an unknown sha, then prints errorstats, evalsha cmdstats (usec stripped) and total_error_replies.
Clean: errorstat_NOSCRIPT count=1, failed_calls=1, total_error_replies=1.
Buggy: NOSCRIPT is sent with addReply instead of addReplyErrorObject, so errorstats are empty, failed_calls=0 and total_error_replies=0.
