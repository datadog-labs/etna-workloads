Input: `export let blah: Yadda<string>;` with an empty selection (cursor) right after the closing `>`.
The script asks the language service for applicable refactors at that position.
Clean: offers "Extract type" / "Extract to type alias" (token touching the cursor is considered).
Injected: that refactor is missing from the list (only the token at the position is looked at).
