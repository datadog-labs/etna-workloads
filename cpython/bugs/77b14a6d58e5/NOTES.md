Feeds `<a x="&centz" y="&cent=z" z="&cent z">` to HTMLParser and prints attrs.
Clean: unterminated `&cent` is left alone when followed by alphanumeric or `=`
(`&centz`, `&cent=z`) and unescaped otherwise. Buggy: uses plain `unescape`, so
`&centz` becomes `¢z` etc.
