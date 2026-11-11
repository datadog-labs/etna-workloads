#!/bin/bash
$RUSTC --crate-type lib --edition 2021 foreign.rs --crate-name foreign -o libforeign.rlib 2>&1
$RUSTC --edition 2021 main.rs --extern foreign=libforeign.rlib -o main 2>&1
echo "status $?"
