#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 crate2.rs 2>&1
"$RUSTC" --crate-type lib --edition 2021 crate1.rs --extern crate2=libcrate2.rlib 2>&1
"$RUSTC" --edition 2021 main.rs --extern crate1=libcrate1.rlib -L . --emit=metadata -o out.rmeta 2>&1
echo "status $?"
