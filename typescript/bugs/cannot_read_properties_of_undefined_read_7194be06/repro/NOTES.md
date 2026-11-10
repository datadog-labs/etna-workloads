Input: an IIFE containing `config.values.push(config.value)` (strict), giving error 2345 (`{}` not assignable to `never`).
The script asks the language service for code fixes at that diagnostic's span.
Clean: no fixes (`fixes: []`). Injected: the returnValueCorrect fix looks up the IIFE's enclosing call, finds the function is not an argument (index -1) and crashes with a TypeError.
