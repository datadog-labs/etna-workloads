#!/bin/bash
"$RUSTC" --crate-type lib --emit llvm-ir -C opt-level=0 --target x86_64-unknown-linux-gnu main.rs -o out.ll 2>&1
echo "status $?"
grep -o 'define [^@]*@c_ret_bool' out.ll
