repro.py parses a 20001-char IPv6 string with ipaddress.IPv6Address and prints the truncated error message.
Clean: "At most 45 characters expected in ..." (early length-limit check). Buggy: the check is missing, so it splits the whole string and reports "At most 8 colons permitted in ..." instead.
