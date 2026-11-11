#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/invalid-direct-const-arg-owner-issue-159172.rs#expr
cd "$(dirname "$0")"
"$RUSTC" --cfg expr -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
