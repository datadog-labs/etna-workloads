#!/bin/bash
$RUSTC --edition 2021 -Ainternal_features --target powerpc64-unknown-linux-musl -Copt-level=3 --emit=asm -o out.s main.rs 2>&1 
echo "status ${?}"
sed -n '/^read_medium:/,/blr/p' out.s | grep -v '^\.' 
