Uses the language service's "Move to file" refactor to move a statement from /a.ts into /bar.ts, which exists and contains only a comment (no statements).
Clean: treats bar.ts as an existing file and edits it by inserting the moved code and imports.
Injected: treats it as a new file (the createNewFile path), so the text changes differ from clean.
The script prints the resulting text changes.
