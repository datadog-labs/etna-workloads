#!/bin/bash
"$RUSTC" --target powerpc64-ibm-aix --emit asm -O -Cpanic=abort -o out.s main.rs 2>&1 | grep -v -e '-->'
echo "status ${PIPESTATUS[0]}"
