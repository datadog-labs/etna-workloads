#!/bin/bash
T="--target arm64ec-pc-windows-msvc --edition 2024 -Copt-level=3 -Awarnings"
"$RUSTC" $T --crate-type lib --crate-name minicore --emit=metadata,link --out-dir . minicore.rs 2>&1 | head
"$RUSTC" $T --crate-type lib --emit=asm -o out.s -L . main.rs 2>&1 | head -20
echo "status ${PIPESTATUS[0]}"
awk '/^"#read_i128":/{f=1} f&&/ret$/{print;exit} f' out.s
