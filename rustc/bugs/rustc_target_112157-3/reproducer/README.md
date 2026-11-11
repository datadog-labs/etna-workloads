Compiles a by-value 32-byte struct argument and return to LLVM IR; the indirect argument should carry 'align 8' on the pointer, but the injected compiler omits the align attribute.
