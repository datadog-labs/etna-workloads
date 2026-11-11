#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 aux.rs --crate-name aux 2>&1
"$RUSTC" --edition 2021 main.rs --extern aux=libaux.rlib -o m 2>&1
echo "status $?"
