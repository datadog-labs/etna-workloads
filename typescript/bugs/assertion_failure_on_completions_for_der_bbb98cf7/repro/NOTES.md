Language-service completions inside `class Derived extends Base` where Base has computed property `[SOME_CONSTANT]: boolean`.
Clean: offers the `[SOME_CONSTANT]` member-snippet completion (insertText `[SOME_CONSTANT]: boolean;`).
Injected: the entry is missing (prints `none`).
