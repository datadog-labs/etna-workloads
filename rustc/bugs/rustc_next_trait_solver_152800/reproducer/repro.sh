#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata -Znext-solver -o out.rmeta main.rs 2>&1 | grep -v '^ *$' | head -20
echo "status=${PIPESTATUS[0]}"
