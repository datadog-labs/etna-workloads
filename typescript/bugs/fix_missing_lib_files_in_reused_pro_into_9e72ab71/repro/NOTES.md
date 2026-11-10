Creates a program with one file, edits it, then recreates the program passing the old program (structure reuse).
Prints whether any source file is classified as a default lib via isSourceFileDefaultLibrary for both programs.
Clean: the reused program still reports lib files as default libraries (true). Injected: the reused program reports false (libFiles not carried over).
