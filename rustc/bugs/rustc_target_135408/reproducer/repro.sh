#!/bin/bash
$RUSTC --target i686-unknown-linux-gnu --edition 2021 -O -Awarnings --emit asm -o out.s main.rs --crate-name m 2>&1 | head -5
echo "status=$?"
sed -n '/^return_f32:/,/ret/p' out.s | grep -E 'movss|movl|flds' | sed 's/^[ \t]*//'
