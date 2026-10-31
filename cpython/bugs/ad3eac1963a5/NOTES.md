Calls time.strftime and datetime.strftime with a format containing an embedded NUL ('%S\0%M').
Clean: the NUL passes through ('00\x0000' / '33\x0022'). Buggy: ValueError "embedded null character".
