input.ts declares class fields combining `accessor` with `readonly` and with `declare`.
Clean tsc reports "'readonly'/'declare' modifier cannot be used with 'accessor' modifier" errors (exit 1).
The injected tsc omits these grammar errors for those combinations, so the output differs.
