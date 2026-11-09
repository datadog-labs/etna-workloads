a.js has a JSDoc `@implements { A }` tag with a space before the closing brace, checked via tsc with allowJs/checkJs.
Clean: no diagnostics, exit 0. Injected: the parser doesn't skip whitespace before `}`, so it reports TS1005 "'}' expected" and exits non-zero.
