#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 ext.rs --crate-name ext --emit metadata,link -o libext.rlib 2>&1
"$RUSTC" --edition 2021 main.rs --extern ext=libext.rlib --emit metadata -o main.rmeta 2>&1
echo "exit=$?"
