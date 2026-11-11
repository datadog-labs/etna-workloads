Compiles an extern "C" fn returning bool for x86_64 and prints its LLVM signature; the clean compiler emits 'zeroext i1' on the return, the injected one emits plain 'i1'.
