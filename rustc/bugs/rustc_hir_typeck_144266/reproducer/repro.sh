#!/bin/bash
"$RUSTC" --crate-type lib --crate-name ext --edition 2021 ext.rs -o libext.rlib 2>&1
echo "ext: $?"
"$RUSTC" --edition 2021 --extern ext=libext.rlib --emit=metadata -o out.rmeta --error-format=short main.rs 2>&1
"$RUSTC" --edition 2021 --extern ext=libext.rlib --emit=metadata -o out.rmeta main.rs 2>&1 | grep -E "help|note: .*implements"
echo "done"
