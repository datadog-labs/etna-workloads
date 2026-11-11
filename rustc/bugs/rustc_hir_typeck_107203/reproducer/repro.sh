#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --out-dir . --error-format human --color never main.rs 2>&1
echo "status=$?"
