#!/bin/bash
"$RUSTC" --crate-type bin --emit metadata --check-cfg 'cfg()' main.rs 2>&1
echo "status=$?"
