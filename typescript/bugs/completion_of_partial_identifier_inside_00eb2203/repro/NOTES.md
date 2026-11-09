Language-service completions are requested inside a JSX attribute expression, at `<div a={v} />` in a .tsx file, with snippet and insert-text preferences enabled.
Clean build: the `value` entry has no insertText (`undefined`), so it's an ordinary expression completion.
Injected build: the partial identifier is treated as an attribute name, so `value` gets insertText `value="$1"`.
