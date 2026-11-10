#!/bin/bash
"$RUSTC" --edition 2021 main.rs -o m 2>&1 || exit 1
RUST_BACKTRACE=0 ./m 2>&1 | grep -A3 '^assertion failed'
