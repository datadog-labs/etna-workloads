main.mts imports "double-asterisk/a/*/b/*/c/*", where the package's exports key has more than one `*`.
Clean: such a key is not treated as a pattern, so resolution fails and tsc reports an error (exit 2).
Injected: the multi-`*` key is used as a pattern, the import resolves, and tsc prints no errors (exit 0).
