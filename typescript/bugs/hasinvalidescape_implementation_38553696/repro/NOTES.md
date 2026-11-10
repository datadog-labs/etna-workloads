Input: tagged templates with valid escapes (`\x41`, `B`, `\u{43}`) compiled with --target es2015.
Clean: emitted as-is, since the escapes are valid.
Injected: hasInvalidEscape treats any template flag (hex/unicode escape) as invalid, so output is downleveled to `__makeTemplateObject(...)` calls.
