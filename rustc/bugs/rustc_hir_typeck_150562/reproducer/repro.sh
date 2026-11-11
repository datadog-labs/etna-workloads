#!/bin/bash
"$RUSTC" --edition=2021 --emit=metadata --out-dir . main.rs 2>&1 | grep -E "self type must|error\["
echo "status ${PIPESTATUS[0]}"
