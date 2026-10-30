Adds two geo points and runs GEORADIUS ... ASC WITHDIST from the first point (distance < 1).
Clean prints `0.0001` and `9.8182`; the buggy build leaves junk/missing zero-fill in the small distance reply.
