#!/bin/bash
# Auto-generated from tests/ui/extern-flag/empty-extern-arg.rs
cd "$(dirname "$0")"
"$RUSTC" --extern std= -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
