#!/bin/bash
# Auto-generated from tests/ui/moves/region-var-in-moved-ty-issue-133118.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
