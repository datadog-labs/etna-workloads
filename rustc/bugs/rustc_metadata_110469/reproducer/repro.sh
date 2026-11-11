#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib main.rs -o main.out 2>&1 | grep -v '^thread\|^stack\|^  *[0-9]*:\|^  *at ' | head -30
echo "status: ${PIPESTATUS[0]}"
