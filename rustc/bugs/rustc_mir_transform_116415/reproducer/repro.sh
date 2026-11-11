#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -Zmir-opt-level=3 -Zvalidate-mir main.rs 2>&1 | grep -E "^error|Failed subtyping" | sed 's/{coroutine@[^}]*}/{coroutine}/'
echo "status=${PIPESTATUS[0]}"
