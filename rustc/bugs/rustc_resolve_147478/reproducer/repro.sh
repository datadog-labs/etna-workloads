#!/bin/bash
# Auto-generated from tests/ui/resolve/private-constructor-self-issue-147343.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
