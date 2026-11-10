#!/bin/bash
# Auto-generated from tests/ui/lint/decorate-ice/decorate-can-emit-warnings.rs
cd "$(dirname "$0")"
"$RUSTC" -Dunused_must_use -Awarnings --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
