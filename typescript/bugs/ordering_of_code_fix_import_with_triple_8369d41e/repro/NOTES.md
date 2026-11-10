Input: a module with `/// <reference lib="dom" preserve="true" />` and a declaration, compiled to JS with tsc.
Clean build keeps the `<reference lib>` directive comment in the emitted JS.
Injected build no longer recognizes `<reference lib>` (and `<amd-module>`) as triple-slash directives, so the comment is dropped from the output.
