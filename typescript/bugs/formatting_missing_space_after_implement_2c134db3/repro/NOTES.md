Formats a file via the language service (getFormattingEditsForDocument) containing `class B implements A<string>{` and `interface I extends A<number>{`.
Clean inserts a space before `{` after the generic `>`; the injected build leaves `A<string>{` unformatted.
