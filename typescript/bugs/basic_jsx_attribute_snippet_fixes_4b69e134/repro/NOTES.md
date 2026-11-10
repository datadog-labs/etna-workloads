Language-service script requests JSX attribute completions (braces snippet style) in a .tsx file at `<Foo something={false} cla />` and at a blank spot after `{false}`.
Clean: `className` is offered with insertText `className={$1}` as a snippet at both positions.
Injected: the JSX-attribute context is not detected when the previous token is `}` and the current token isn't `>`, or for `cla` after an attribute expression. The snippet completion is missing or differs.
