#!/bin/bash
"$RUSTC" main.rs --edition=2024 -Zunpretty=stable-mir --crate-type lib -C panic=abort -Zmir-opt-level=0 2>&1 | grep 'discriminant('
echo "status ${PIPESTATUS[0]}"
