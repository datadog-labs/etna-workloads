Parses f-strings with nested replacement fields in the format spec and prints the node types in `format_spec.values`.
Clean: `['FormattedValue']` / `['FormattedValue', 'FormattedValue']`. Buggy: spurious empty `Constant` nodes appear in the spec values.
