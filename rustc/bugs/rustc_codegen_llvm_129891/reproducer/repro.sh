#!/bin/bash
"$RUSTC" --edition 2021 -Copt-level=0 -Zsanitizer=address -Ctarget-feature=-crt-static --target x86_64-unknown-linux-gnu --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
# attribute group used by the naked function declaration
grp=$(grep 'declare.*page_fault_handler' out.ll | grep -o '#[0-9]*' | tail -1)
echo "naked decl found: $([ -n "$grp" ] && echo yes)"
grep "^attributes $grp " out.ll | grep -c sanitize_address
