#!/bin/bash
for t in aarch64-unknown-linux-gnu aarch64-unknown-none; do
echo "== $t"
"$RUSTC" --target $t --crate-type=lib --emit=asm -o out.s -Zunstable-options -Zsanitizer=shadow-call-stack -Zfixed-x18 lib.rs 2>&1 | grep -v '^$' | head -5
echo "status ${PIPESTATUS[0]}"
done
