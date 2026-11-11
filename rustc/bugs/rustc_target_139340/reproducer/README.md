Shows LLVM IR for an extern "C" fn passing/returning repr(C) {f32,f64} on riscv64: the fixed compiler casts with an offset pair, the injected one uses a plain pair (wrong layout).
