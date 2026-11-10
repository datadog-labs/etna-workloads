Input has a plain `export default x;` compiled with `--erasableSyntaxOnly`.
Clean: no errors (default export is erasable), exit 0.
Injected: reports "This syntax is not allowed when 'erasableSyntaxOnly' is enabled" on the default export (TS1294), exit 2.
