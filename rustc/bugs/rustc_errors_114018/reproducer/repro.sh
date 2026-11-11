#!/bin/bash
"$RUSTC" --crate-type lib --crate-name other_file --edition 2021 other.rs -o libother_file.rlib 2>&1
"$RUSTC" --edition 2021 --extern other_file=libother_file.rlib --error-format human main.rs -o out 2>&1
echo "status=$?"
