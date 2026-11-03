Reproducer (repro.sh) is the issue74836 test (struct T{[20]int} passed with a [4]int to a bodyless func), built with `go build`.
Without the SP-preference in regalloc, locals can be addressed via a copy of SP in another register; the assembler rejects this
("invalid instruction ... autotmp+N(DX)"). The buggy toolchain fails building package runtime with such errors; the clean one builds fine.
