repro.sh compiles a file with a >70-char string constant using `go tool compile -asmhdr` and prints the const_ lines of go_asm.h.
Clean: full string in `#define const_longStringVal "..."`. Buggy: the string is truncated with "..." (uses %v instead of ExactString()).
