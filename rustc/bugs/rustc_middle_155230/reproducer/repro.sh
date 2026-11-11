#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --out-dir . main.rs 2>&1 | sed 's/-->.*main.rs/--> main.rs/'
echo "status=${PIPESTATUS[0]}"
