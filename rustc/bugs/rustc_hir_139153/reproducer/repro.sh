#!/bin/bash
"$RUSTC" --edition=2021 --crate-type=lib --emit=mir -o out.mir main.rs 2>&1
echo "status $?"
grep -o 'fn foo::[^(]*' out.mir | sort
