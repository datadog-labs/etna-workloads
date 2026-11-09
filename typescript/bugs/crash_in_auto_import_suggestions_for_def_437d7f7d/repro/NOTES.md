Input: a CommonJS `dottie` package (`exports = module.exports = Dottie` with `Dottie["default"] = ...`) and an empty JS file; the script asks the language service for auto-import completions at position 0.
Clean: returns a `Dottie` completion entry from source `dottie` (hasAction true).
Injected: the default-like export name lookup returns nothing for the `default` member, so the `Dottie` entry is missing (or the call crashes); the output differs.
