Input: a .tsx file with `jsx: react-jsx` and a global JSX namespace declaring `ElementChildrenAttribute { offspring }`, then `<Title>Hello</Title>` where Title takes `children: string`.
Clean: `children` is always used under react-jsx, so no children-related error (only the unrelated runtime/IntrinsicElements ones).
Injected: it honours `ElementChildrenAttribute`, so it reports an extra TS2745 on the `<Title>` tag.
