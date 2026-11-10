On sparc64/s390x/powerpc linux-gnu, extern "C" ZST args must be passed indirectly (a pointer param appears in the LLVM IR signature); the injected compiler ignores them, dropping the parameter.
