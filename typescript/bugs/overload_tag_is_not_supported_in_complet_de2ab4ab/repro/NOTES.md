Input: a JS file containing a JSDoc comment with a bare `@`; the script asks the language service for completions at that position.
Clean: the tag-name completions include `overload` (and `override`), so the script prints both.
Injected: `overload` is missing from the list, so only `override` is printed.
