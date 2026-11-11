#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --error-format=human --color never main.rs 2>&1 | grep -v '^ *-->' 
echo "status ${PIPESTATUS[0]}"
