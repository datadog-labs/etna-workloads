# util: fix OSC 8 hyperlink stripping in stripVTControlCharacters

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f6448536809991c4c4f06555742c00bf5cac5706 applied to v26.13.0 (clean).

Upstream commit message:

```
util: fix OSC 8 hyperlink stripping in stripVTControlCharacters

The bundled ansi-regex OSC pattern used a restrictive URI
character class that failed when URIs contained RFC 3986-valid
characters such as parentheses.

Match OSC sequences generically as ESC ] ... ST, aligned with
ansi-regex v6.2.0.

Co-authored-by: Cursor <cursoragent@cursor.com>
Signed-off-by: dushyant <dushyanthada90@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64319
Fixes: https://github.com/nodejs/node/issues/64313
Reviewed-By: Aviv Keller <me@aviv.sh>
```
