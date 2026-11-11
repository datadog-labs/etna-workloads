#!/bin/bash
$RUSTC --crate-type lib --edition 2021 alias.rs 2>&1
$RUSTC --edition 2021 --emit metadata --extern alias=libalias.rlib main.rs 2>&1 | grep -E '^(error|thread)' | sed 's/(.*)//'
echo "status ${PIPESTATUS[0]}"
