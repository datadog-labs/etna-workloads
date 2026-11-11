#!/bin/bash
"$RUSTC" --crate-type proc-macro --crate-name derive_demo derive_demo.rs 2>&1
"$RUSTC" --edition 2021 --emit metadata --extern derive_demo=libderive_demo.so main.rs --error-format short --color never 2>&1
echo "status $?"
"$RUSTC" --edition 2021 --emit metadata --extern derive_demo=libderive_demo.so main.rs --color never 2>&1 | grep -c "Into::into"
