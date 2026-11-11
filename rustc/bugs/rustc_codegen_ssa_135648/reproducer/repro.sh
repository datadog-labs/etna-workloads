#!/bin/bash
$RUSTC --edition 2021 --target wasm32-unknown-unknown --crate-type rlib --crate-name minicore -Zunstable-options -Awarnings -o libminicore.rlib minicore.rs 2>&1 | head -5
$RUSTC --edition 2021 --target wasm32-unknown-unknown --emit asm -Awarnings -o out.s --extern minicore=libminicore.rlib main.rs 2>&1 | head -20
grep -E "weak|globl" out.s | grep -v section
