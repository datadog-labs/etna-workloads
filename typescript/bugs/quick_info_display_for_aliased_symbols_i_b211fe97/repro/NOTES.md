Input: `someEnv` is imported (alias to `string | undefined`) and narrowed by a type guard to `string`; the language service asks for quick info on `someEnv` inside the `if`.
Clean prints `(alias) const someEnv: string` then `import someEnv`.
Injected ignores the narrowed type and prints `(alias) const someEnv: string | undefined`.
