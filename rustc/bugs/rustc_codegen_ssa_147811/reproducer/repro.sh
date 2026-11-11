#!/bin/bash
for t in x86_64-unknown-uefi aarch64-apple-darwin; do
echo "== $t"
"$RUSTC" --target $t --crate-type lib --emit link -O --edition 2021 -Zunstable-options -o libminicore.rlib minicore.rs 2>&1 | grep -E "^error" | head
"$RUSTC" --target $t --crate-type lib --emit asm --extern minicore=libminicore.rlib --edition 2021 -o out.s main.rs 2>&1 | grep -E "^(error|warning: unused)" | head -3
echo "status ${PIPESTATUS[0]}"
grep -E "section" out.s 2>/dev/null; rm -f out.s
done
