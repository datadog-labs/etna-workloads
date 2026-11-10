#!/bin/bash
"$RUSTC" --edition 2021 -Zsanitizer=kcfi -Cpanic=abort -Cunsafe-allow-abi-mismatch=sanitizer -Cno-prepopulate-passes -Copt-level=0 --emit=llvm-ir -o out.ll main.rs 2>&1 | grep -E 'internal compiler error|^error' | head -3
echo "status=${PIPESTATUS[0]}"
[ -f out.ll ] && grep -c 'reify_fnptr' out.ll
