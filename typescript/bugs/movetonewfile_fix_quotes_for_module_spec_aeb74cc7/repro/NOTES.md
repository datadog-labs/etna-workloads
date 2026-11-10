Input: b.ts imports `x` from './a' (single quotes, no semicolon); the language service runs the "Move to a new file" refactor on the usage `x;`.
The new file has no imports yet, so the import it writes should copy the quote style of the original file (`'./a'`).
Clean: the generated import uses single quotes. Injected: the quote preference isn't inherited for the new file, so the quotes differ (double quotes).
