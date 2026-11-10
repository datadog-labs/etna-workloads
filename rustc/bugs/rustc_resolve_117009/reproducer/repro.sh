#!/bin/bash
"$RUSTC" --crate-type lib --crate-name library --edition 2021 lib.rs -o liblibrary.rlib 2>&1
"$RUSTC" --edition 2021 --crate-type lib --extern library=liblibrary.rlib main.rs --emit metadata -o out.rmeta 2>&1
echo "status $?"
