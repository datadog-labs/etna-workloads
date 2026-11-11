#!/bin/bash
"$RUSTC" --check-cfg "cfg()" --crate-type bin --emit metadata --out-dir . main.rs 2>&1
echo "exit: $?"
