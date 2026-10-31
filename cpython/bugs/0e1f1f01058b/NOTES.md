Sets a cookie with Path=/foo, then requests /foobad/foo. Clean: no Cookie header sent
and set_ok_path returns False. Buggy: plain startswith() prefix match sends
'spam=eggs' and set_ok_path returns True.
