Compiles a no_core crate for i686 with -Zregparm=2 and emits LLVM IR; the clean compiler records the NumRegisterParameters module flag (count 1), the injected one omits it (count 0).
