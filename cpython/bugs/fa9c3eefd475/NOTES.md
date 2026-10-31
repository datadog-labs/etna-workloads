Builds a re.Scanner with a capturing group in a lexicon pattern.
Clean: raises ValueError("Cannot use capturing groups in re.Scanner").
Buggy: no error is raised, so it prints "no error".
