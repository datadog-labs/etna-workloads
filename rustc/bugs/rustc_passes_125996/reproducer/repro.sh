#!/bin/bash
$RUSTC --crate-type=lib --crate-name aux --edition 2021 -O aux.rs 2>&1; echo "aux: $?"
$RUSTC --edition 2021 -O main.rs -L . -o main 2>&1 | grep -v '^ *-->' ; echo "main: ${PIPESTATUS[0]}"
[ -x main ] && ./main
