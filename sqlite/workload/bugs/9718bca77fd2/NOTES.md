Matches 'abc' against patterns that should fail at the end-of-string NUL: `\W`, `[^a-z]`, `\W{1}`.
Clean shell prints 0 for each. Buggy shell prints 1, because \W, \D, \S and negated character classes now match the terminating NUL.
