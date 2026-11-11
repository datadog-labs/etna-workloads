#!/bin/bash
$RUSTC --crate-type=dylib --crate-name=aux -Cprefer-dynamic -O aux.rs 2>&1
$RUSTC main.rs -O -Cprefer-dynamic -Ccodegen-units=1024 -L . -o a.out 2>&1 | grep -E '^error' | head -3
echo "compile status: ${PIPESTATUS[0]}"
