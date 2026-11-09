Formats a file where a `satisfies` expression has a multi-line mapped type on its right side, using the language service's document formatting.
Clean: the mapped type body is indented only relative to the `satisfies` line, so `[index in Z]: string` gets 4 spaces and `}` is at column 0.
Injected: SatisfiesExpression no longer skips indentation for mapped types, so the mapped type is indented an extra level.
