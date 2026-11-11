#!/bin/bash
"$RUSTC" --crate-type lib --emit metadata --out-dir . main.rs 2>&1
echo "exit: $?"
