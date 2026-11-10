Class `ExpressionParser` extends `Tokenizer`, whose method `errorBuilder()` returns an unannotated arrow function with typed parameters.
The script asks the language service for completions inside the subclass body, passing formatting settings, and prints the `errorBuilder` entry's insertText.
Clean: prints `errorBuilder(): (pos: number, lineStart: number, curLine: number) => void {\n}`.
Injected: the parameter nodes get an empty modifiers array, so the snippet formatter throws and the script prints "crashed".
