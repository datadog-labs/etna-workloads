Input: a function whose `if/else` and `while` bodies sit on the same line as their condition (`if (true) console.log(1);`).
`repro.sh` uses the language service to apply the "Extract function" refactor to those statements and prints the generated text.
Clean: same-line embedded statements keep their layout (`if(true) console.log(1);`).
Injected: the preserve-newlines check in `emitEmbeddedStatement` is gone, so the output differs (the body is moved onto its own line).
