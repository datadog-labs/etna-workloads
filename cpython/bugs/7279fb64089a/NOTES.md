repro.py tokenizes `'a\n '` and `'b = 1\n\n#test'` (no trailing newline) with tokenize.tokenize and prints each token.
Clean: the final NL token has string=''. Buggy: it has string='\n' (spurious newline text).
