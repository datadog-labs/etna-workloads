#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --out-dir . main.rs 2>&1
echo "status: $?"
