#!/bin/bash
"$RUSTC" --edition=2021 --crate-type=lib main.rs 2>&1 | grep -E '^error' 
echo "status=${PIPESTATUS[0]}"
