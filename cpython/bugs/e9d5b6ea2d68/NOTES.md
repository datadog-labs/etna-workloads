Folds unstructured headers mixing an `unknown-8bit` encoded word with adjacent utf-8/ascii text
via `email._header_value_parser.get_unstructured(...).fold(policy=policy.default)`.
Clean: the encoded words are kept separate (e.g. `'=?unknown-8bit?q?=A4?==?utf-8?q?=C2=A4?=\n'`).
Buggy: the `last_ew = None` reset is missing, so the words are combined and
`UnicodeEncodeError: 'utf-8' codec can't encode character '\udca4'` is raised.
