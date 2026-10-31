from http.cookiejar import http2time

# Malicious date string from the upstream bpo-38804 fix (overlapping \s*
# groups in LOOSE_HTTP_DATE_RE cause catastrophic backtracking).
text = "1-c-1" + (" " * 2000) + "!"
print(repr(http2time(text)))
