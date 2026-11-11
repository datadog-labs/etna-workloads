#!/bin/bash
set -e
$RUSTC --edition 2021 -Copt-level=3 --crate-type lib leaf.rs --crate-name leaf -o libleaf.rlib
$RUSTC --edition 2021 -Copt-level=3 --crate-type lib main.rs --extern leaf=libleaf.rlib --emit asm -o out.s 2>&1
if grep -q '\(call\|jmp\).*leaf_with_assert' out.s; then echo "call remains"; else echo "inlined"; fi
