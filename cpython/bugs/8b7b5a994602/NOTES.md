Reproducer: calls unicodedata.name() and unicodedata.lookup() on Tangut ideographs (U+17000, U+187FF, U+18D00, U+18D1E). Egyptian, Khitan and Nushu characters are included as controls.

Clean: name() returns "TANGUT IDEOGRAPH-17000" etc., and lookup() round-trips.
Buggy: name() returns None for the Tangut code points, and lookup("TANGUT IDEOGRAPH-...") raises KeyError. The controls behave the same on both.
