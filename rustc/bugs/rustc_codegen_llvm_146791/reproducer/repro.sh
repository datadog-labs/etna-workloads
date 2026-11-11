#!/bin/bash
$RUSTC --edition 2021 --crate-type lib --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep -o 'call.*asm.*#[0-9]*' out.ll | grep -o '#[0-9]*$' | while read a; do grep "^attributes $a " out.ll | grep -o 'memory([^)]*)' || echo "no memory attr"; done
