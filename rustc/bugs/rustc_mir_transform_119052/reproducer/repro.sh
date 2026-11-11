#!/bin/bash
"$RUSTC" --edition 2021 -O -Zmir-opt-level=2 main.rs -o m 2>&1 | grep -v '^ *[0-9]*:' | head -5
echo "status=${PIPESTATUS[0]}"
[ -x m ] && ./m
