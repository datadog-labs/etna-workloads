#!/bin/bash
$RUSTC --crate-type proc-macro --crate-name pm pm.rs -o libpm.so 2>&1 | head -5
$RUSTC --edition 2021 --emit metadata --extern pm=libpm.so main.rs -o main.rmeta 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | head -12
echo "status: ${PIPESTATUS[0]}"
