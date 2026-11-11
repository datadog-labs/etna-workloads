#!/bin/bash
"$RUSTC" --crate-type lib --emit metadata --target arm64ec-pc-windows-msvc -Cpanic=abort --out-dir . main.rs 2>&1
echo "status=$?"
