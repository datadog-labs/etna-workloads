Reproducer: in one CLI session, select DB 10, set mykey, run EVAL calling redis.pcall('select','9'), then GET mykey.
Clean: caller stays in DB 10, GET returns "original". Buggy: the caller's DB is switched to 9, so GET returns nothing.
