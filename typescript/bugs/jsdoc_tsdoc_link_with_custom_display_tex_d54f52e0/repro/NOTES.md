Input is a JS file (checkJs) with `@typedef {number} https://wat` and a variable documented with `{@link https://hva}`. The repro prints the quick-info documentation parts from the language service.
Clean: the whole `https://hva` is one `linkName` part.
Injected: the link name is split at `:`, giving `linkName` "https" plus `linkText` "://hva".
