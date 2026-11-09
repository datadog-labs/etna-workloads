Input: a type with property `foo`, a shorthand-destructured `let { foo }: Props`, and an object literal `{ "foo": true }`.
The script asks the language service to rename at the string literal "foo" with providePrefixAndSuffixTextForRename.
Clean: the destructuring occurrence gets prefixText "foo: " (so the rename stays correct).
Injected: string-literal origin is ignored, so that occurrence gets no prefix/suffix text.
