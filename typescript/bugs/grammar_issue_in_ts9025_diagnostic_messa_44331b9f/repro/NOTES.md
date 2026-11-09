Input: an exported function with a defaulted parameter of type `T` (an alias for `number[]`, no `undefined`) followed by a required parameter, compiled with `--isolatedDeclarations --declaration --strict`.
This triggers TS9025 ("Declaration emit for this parameter requires implicitly adding undefined to its type...").
Clean prints "to its type"; injected prints "to it's type".
