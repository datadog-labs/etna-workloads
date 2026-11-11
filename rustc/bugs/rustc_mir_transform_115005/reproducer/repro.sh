#!/bin/bash
"$RUSTC" --crate-type=lib --crate-name aux --edition 2021 aux.rs 2>&1; echo "aux status $?"
"$RUSTC" --crate-type=lib --edition 2021 -Zvalidate-mir -L . main.rs 2>&1 | grep -E "^error|broken MIR|Field projection" | sed 's/DefId([^)]*)/DefId/'
echo "status ${PIPESTATUS[0]}"
