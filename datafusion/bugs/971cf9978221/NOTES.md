repro.sql sets the SQL parser dialect to postgresql and evaluates `2 ^ 3` and `2.0 ^ 0.5`.
Clean build lowers `^` to power() and returns 8.0 and 1.414...; the buggy build fails both queries with "Unsupported binary operator: PGExp".
