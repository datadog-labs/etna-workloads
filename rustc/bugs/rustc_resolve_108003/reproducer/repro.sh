#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata -o out.rmeta main.rs 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | sed 's/thread .rustc. ([0-9]*)/thread/'
echo "status: ${PIPESTATUS[0]}"
