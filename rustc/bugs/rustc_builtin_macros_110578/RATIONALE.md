# Adapted injection for fix(error): normalize whitespace during msg_to_buffer

Fix: https://github.com/rust-lang/rust/commit/a2f275da511bbe03ca53bb4c90a344340b1c8fff

# Rationale
Hunk: compiler/rustc_builtin_macros/src/env.rs, expand_env, `EnvNotDefined::CustomEnvVar { var: Symbol::intern(var) }` (was `*symbol`).

Fix hunk re-expressed: `@@ -1336,6 +1336,7 @@ impl EmitterWriter` in emitter.rs, adding
`let text = &normalize_whitespace(&text);` in msg_to_buffer. The old emitter was removed (3ccabc6a8dc); normalization now
happens inside the annotate-snippets crate (not editable), and 1.99 avoids the issue by passing the raw literal text
(`\t`) as the diagnostic argument. Re-injecting: pass the unescaped value so the message again contains raw tab/bidi
characters, and the diagnostic text differs from the expected output (whitespace/control char replaced in the message
rather than the escaped form shown). This is an approximation: it reintroduces the "raw whitespace in message" condition
that the fix's normalization addressed, but does not crash.
