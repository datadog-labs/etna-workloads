With -Zfixed-x18 (x18 reserved) on aarch64, clobber_abi("C") must not list w18 as clobbered in the emitted LLVM IR; the injected compiler wrongly includes ={w18}.
