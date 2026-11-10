Input: a .tsx file with `<foo cl={""} />`; completions requested at the end of `cl` with jsxAttributeCompletionStyle "braces" and snippet text enabled.
Clean: the `className` entry has no insertText/isSnippet (attribute already has an initializer).
Injected: the entry gets insertText `className={$1}` with isSnippet true, producing a duplicate initializer.
