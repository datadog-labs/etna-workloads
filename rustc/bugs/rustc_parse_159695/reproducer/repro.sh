#!/bin/bash
$RUSTC --crate-type proc-macro --crate-name pm --edition 2024 pm.rs 2>&1; echo "pm: $?"
$RUSTC --edition 2024 --cfg enabled --check-cfg 'cfg(enabled)' --emit metadata --extern pm=libpm.so main.rs 2>&1; echo "main: $?"
