#!/bin/bash
$RUSTC --edition 2021 -Zsanitizer=address -Ctarget-feature=-crt-static -Cunsafe-allow-abi-mismatch=sanitizer -Cprefer-dynamic=false -Clto=fat --emit=llvm-ir -o out.ll main.rs 2>&1 | head -5
echo "status=${PIPESTATUS[0]}"
grep -o '^@___asan_globals_registered = [a-z ]*global' out.ll
