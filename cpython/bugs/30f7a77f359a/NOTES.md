repro.py: builds an EmailMessage with a unixfrom line and calls as_string(unixfrom=True). Clean output includes the 'From ...' line; buggy drops it (unixfrom not forwarded to Message.as_string).
