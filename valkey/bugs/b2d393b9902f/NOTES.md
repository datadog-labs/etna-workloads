Reproducer: adds two geo points near the pole (and a pole-crossing pair), then runs GEORADIUSBYMEMBER.
Clean returns both members (n1 n2) in each query; the buggy build's bounding-box step check
decreases the search step too far, so n2 is missing from the results.
