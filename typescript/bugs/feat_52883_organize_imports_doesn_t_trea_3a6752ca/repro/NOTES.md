Input has two groups of `export ... from` declarations separated by a blank line; `organizeImports` is run via the language service.
Clean: each blank-line-separated export group is organized/merged separately (the two "./x" exports merge, the two "./y" exports merge, groups stay apart).
Injected: all export declarations in the file are treated as one group, so the groups are merged/sorted together and the text changes differ.
