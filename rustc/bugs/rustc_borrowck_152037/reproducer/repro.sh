#!/bin/bash
# Auto-generated from tests/ui/lint/unused/mut-used-despite-borrowck-error.rs
cd "$(dirname "$0")"
"$RUSTC" -W unused_mut -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
