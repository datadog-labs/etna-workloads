#!/bin/bash
mkdir -p out
"$RUSTC" main.rs --out-dir out -C codegen-units=2 --emit asm 2>&1
echo "status=$?"
