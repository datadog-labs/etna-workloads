Uses the language service "Move to file" refactor to move all of a.ts (type alias + interfaces) into bar.ts.
Prints the resulting file contents after applying the text edits.
Clean: moved statements are formatted (e.g. the union is re-laid out, 4-space indentation).
Injected: formatting uses the wrong source file, so the output text differs from clean.
