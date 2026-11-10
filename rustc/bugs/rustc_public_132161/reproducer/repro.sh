#!/bin/bash
"$RUSTC" -Z unpretty=stable-mir --crate-type lib -C panic=abort -Zmir-opt-level=0 main.rs 2>&1 | grep -E 'Storage|_2 ='
echo "status ${PIPESTATUS[0]}"
