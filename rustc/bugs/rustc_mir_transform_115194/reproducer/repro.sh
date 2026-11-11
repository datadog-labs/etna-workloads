#!/bin/bash
$RUSTC --crate-type=dylib -Zalways-encode-mir -Cprefer-dynamic internal.rs 2>&1; echo "aux: $?"
$RUSTC -O -Cprefer-dynamic -L . main.rs -o main 2>&1 | grep -E '^error' | head -3; echo "main: ${PIPESTATUS[0]}"
