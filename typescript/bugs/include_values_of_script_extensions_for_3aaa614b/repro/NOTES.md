input.ts uses regexes with `\p{Script_Extensions=Latin}` and `\p{scx=Greek}` (valid Unicode property value expressions).
Clean: tsc reports no errors for them.
Injected: the Script_Extensions value set is empty, so tsc reports "unknown Unicode property value" errors.
