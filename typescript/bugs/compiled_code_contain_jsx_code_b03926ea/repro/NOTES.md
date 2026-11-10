Input spreads a JSX element as an attribute (`<div {...<span />} />`) and compiles with `--jsx react`.
Clean: the spread expression is transformed, giving `Object.assign({}, React.createElement("span", null))`.
Injected: the spread expression is not visited, so raw `<span />` JSX remains in the emitted JS.
