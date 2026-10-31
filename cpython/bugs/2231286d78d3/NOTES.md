Builds a zip with entries `foo\bar.txt` and `../up.txt`, then lists `zipfile.Path(...).iterdir()` names and checks `exists()` for `foo\bar.txt`.
Clean: names are kept verbatim (`['foo\\bar.txt', '..']`, exists True). Buggy: the SanitizedNames mix-in rewrites names (`['up.txt', 'foo']`, exists False).
