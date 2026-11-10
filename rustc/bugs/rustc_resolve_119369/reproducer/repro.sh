#!/bin/bash
"$RUSTC" --crate-type lib --crate-name ext --edition 2021 ext.rs -o libext.rlib 2>&1; echo "aux=$?"
"$RUSTC" --edition 2021 --emit metadata --extern ext=libext.rlib main.rs -o main.meta 2>&1 | grep -E '^(error|note: no errors)' ; echo "main=${PIPESTATUS[0]}"
