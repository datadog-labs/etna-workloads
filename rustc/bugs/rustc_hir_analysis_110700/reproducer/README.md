Reproduces recursive fn return type inference (`fn a() -> _ { a() }`): clean rustc reports E0121 and exits 1; the injected one infers the return type as itself and crashes (SIGSEGV).
