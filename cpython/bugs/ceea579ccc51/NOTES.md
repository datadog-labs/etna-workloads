Reproducer runs csv.Sniffer().has_header on the two samples from test_issue43625.
Clean: True, False. Buggy: int/float/complex are tried separately, so the mixed numeric columns in the first sample are treated as different types and has_header returns False.
