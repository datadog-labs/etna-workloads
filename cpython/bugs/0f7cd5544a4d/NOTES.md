Folds a Subject made of one overlong word with max_line_length=20 using the default email policy.
Clean: `Subject:\n =?utf-8?q?thisisa?=...`. Buggy: `Subject: \n ...`, with a stray trailing space
after "Subject:" (the injected _fold_as_ew no longer steals trailing whitespace when starting a new line).
