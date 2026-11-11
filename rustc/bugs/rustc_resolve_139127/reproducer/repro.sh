#!/bin/bash
"$RUSTC" --crate-type lib --crate-name empty empty.rs 2>&1
"$RUSTC" --edition 2021 --emit metadata --extern empty=libempty.rlib main.rs 2>&1
echo "exit: $?"
