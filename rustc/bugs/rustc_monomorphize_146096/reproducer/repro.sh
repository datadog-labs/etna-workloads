#!/bin/bash
"$RUSTC" main.rs -Copt-level=0 --out-dir out 2>&1 | cut -c1-200 | head -8
echo "status: ${PIPESTATUS[0]}"
