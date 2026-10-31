Reproducer: three `re.fullmatch` calls using possessive quantifiers / atomic groups followed by more pattern (gh-91616).
Clean: all three match. Buggy: `(?:ab)*+c` on 'abc' and `(?s:(?>.*?\.).*)\z` on 'a.txt' return None (fullmatch end-of-string check wrongly propagates into the atomic/possessive sub-match).
