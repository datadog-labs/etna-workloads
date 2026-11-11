#!/bin/bash
# Auto-generated from tests/ui/conditional-compilation/cfg-attr-parsed-span-issue-154801.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
