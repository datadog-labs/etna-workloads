A JSX element whose only child is whitespace/newline text is checked against props where `children` is declared via JSX.ElementChildrenAttribute.
Clean: no error (whitespace-only child isn't a semantic child). Injected: synthesizes a `children` prop and reports an error (excess property `children`), exit 2.
