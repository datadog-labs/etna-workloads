#!/bin/bash
"$RUSTC" --crate-type lib --crate-name ext --edition 2021 ext.rs --emit link -o libext.rlib 2>&1
"$RUSTC" --edition 2021 main.rs --extern ext=libext.rlib --emit metadata -o out.rmeta --error-format short 2>&1 | sed 's/^[^ ]*main.rs/main.rs/'
"$RUSTC" --edition 2021 main.rs --extern ext=libext.rlib --emit metadata -o out.rmeta 2>&1 | grep -A8 '^help'
echo "exit ${PIPESTATUS[0]}"
