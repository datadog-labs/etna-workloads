#!/bin/bash
# Auto-generated from tests/ui/extern-flag/invalid-crate-name-dashed.rs
cd "$(dirname "$0")"
"$RUSTC" --extern=my-awesome-library=libawesome.rlib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
