Tokenizes a multi-line f-string containing non-ASCII text (`tokenize.generate_tokens`) and prints each token with its positions.
Clean: FSTRING_END is at (2, 68)-(2, 71). Buggy: (2, 72)-(2, 75). With the bug, the column offset is not recomputed when the line changes, so a stale byte/char diff is used.
