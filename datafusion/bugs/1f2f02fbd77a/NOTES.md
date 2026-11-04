repro.sql runs `position(1 in 1)` and two `strpos(..., NULL)` queries (one with a Dictionary haystack).
Differences: with the bug, the Dictionary + NULL query fails with "Unsupported data type Dictionary(Int32, Utf8) for strpos haystack" (clean returns NULL).
The planning error for `position(1 in 1)` also differs in wording (user-defined coercion vs. signature mismatch).
