Input: a JSDoc comment with an unmatched `@param {number} n` and `@returns` on an exported arrow-function const.
The script asks the language service for the "Delete unused @param tag" code fix and prints the edited text.
Clean: the tag is removed from the existing JSDoc, leaving `@returns`.
Injected: the fix filters tags on the wrong node, so the output differs (another JSDoc is added).
