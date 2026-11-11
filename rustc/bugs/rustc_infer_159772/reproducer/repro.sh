#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/lower-universe-resolved-const-issue-159703.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
