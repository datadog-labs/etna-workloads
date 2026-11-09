Input has tuple types with spread and extra spaces: `[...  string[]]`, `[...   T]`.
repro.sh applies the language service's document formatting edits and prints the result.
Clean: spaces after `...` removed (`[...string[]]`, `[...T]`). Injected: extra spaces are left in place.
