Input: unions mixing string literals with a string-mapping type (`"abc" | Uppercase<string>`, `"abc" | Lowercase<string>`).
Union subtype reduction should remove literals matched by the template/string-mapping type (e.g. "abc" under Lowercase<string>).
The injected build only checks template literal types, so it doesn't reduce them; the reported types in the errors differ between clean and injected.
