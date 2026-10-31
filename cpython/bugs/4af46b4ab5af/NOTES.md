Reproducer for gh-148192: pins the random boundary token, puts that boundary line
in a text part, and flattens a MIMEMultipart with linesep="\r\n".
Clean prints True (boundary gets ".0" suffix); buggy prints False (the CRLF-terminated
boundary line isn't detected because the regex lacks `\r?`).
