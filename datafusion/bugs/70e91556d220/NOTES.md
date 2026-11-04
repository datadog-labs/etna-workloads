repro.sql runs `SELECT CAST('' AS int);`, a cast of an invalid literal.
Clean build: the error is raised during simplification, so the message is wrapped in "Optimizer rule 'simplify_expressions' failed ... caused by ...".
Buggy build: the simplifier swallows the error, and the error comes from a later stage as a bare "Arrow error: Cast error: ...".
