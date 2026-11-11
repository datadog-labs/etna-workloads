#!/bin/bash
"$RUSTC" --edition=2024 -Zunpretty=expanded main.rs 2>&1 | grep impl
echo "status: ${PIPESTATUS[0]}"
