#!/bin/bash
for t in sparc64-unknown-linux-gnu s390x-unknown-linux-gnu powerpc-unknown-linux-gnu; do
echo "== $t"
"$RUSTC" --target $t --emit=llvm-ir -O -o - main.rs 2>&1 | grep -E 'define|error'
done
