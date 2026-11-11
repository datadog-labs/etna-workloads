#!/bin/bash
$RUSTC main.rs --target=msp430-none-elf --crate-type=rlib -Cpanic=abort -Zprint-type-sizes 2>&1 | grep -E "layout decided|print-type-size type|print-type-size +discriminant|^error" | head -5
echo "status ${PIPESTATUS[0]}"
