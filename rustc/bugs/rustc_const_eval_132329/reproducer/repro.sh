#!/bin/bash
"$RUSTC" --crate-type=lib --emit=metadata -Znext-solver --out-dir . main.rs 2>&1
echo "status: $?"
