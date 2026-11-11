#!/bin/bash
"$RUSTC" --crate-type=lib --crate-name staged_api staged_api.rs --edition 2021 2>&1
"$RUSTC" --crate-type=lib --edition 2021 --extern staged_api=libstaged_api.rlib main.rs --emit=metadata -o out.rmeta 2>&1
echo "exit: $?"
