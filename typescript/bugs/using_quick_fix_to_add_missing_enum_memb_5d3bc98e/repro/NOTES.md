Input: `enum E { a = "a", }` followed by `E.b`; a language service script requests the "Add missing enum member 'b'" code fix and prints the edited text.
Clean: inserts `b = "b",` after the last member, keeping the formatting.
Injected: replaces the whole enum declaration, so the output formatting differs (extra or empty lines, changed layout).
