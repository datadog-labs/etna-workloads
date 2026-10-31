Reproducer checks `tokenize._all_string_prefixes()`, which the injected bug
builds without the `t` / `tr` template-string prefixes.
Clean prints `True True True`; buggy prints `False False False`.
