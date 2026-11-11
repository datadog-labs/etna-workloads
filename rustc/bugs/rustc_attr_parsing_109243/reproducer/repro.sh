#!/bin/bash
# Auto-generated from tests/ui/link-native-libs/issue-109144.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
