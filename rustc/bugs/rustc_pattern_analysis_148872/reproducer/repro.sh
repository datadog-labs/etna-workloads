#!/bin/bash
# Auto-generated from tests/ui/pattern/missing-ctor-with-ill-formed-inner-ty-issue-148192.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
