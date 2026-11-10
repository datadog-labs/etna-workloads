#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --crate-name ext ext.rs --out-dir . 2>&1
"$RUSTC" --edition 2021 --crate-type lib --crate-name empty empty.rs --out-dir . 2>&1
"$RUSTC" --edition 2021 --emit metadata -L . --extern ext --extern empty main.rs --out-dir . 2>&1 | grep -E "^error|panicked|assertion"
echo "status: ${PIPESTATUS[0]}"
