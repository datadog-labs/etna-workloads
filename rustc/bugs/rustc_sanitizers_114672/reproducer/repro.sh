#!/bin/bash
# Auto-generated from tests/ui/sanitizer/issue-114275-cfi-const-expr-in-arry-len.rs
cd "$(dirname "$0")"
"$RUSTC" -Ccodegen-units=1 -Clto -Zsanitizer=cfi -Ctarget-feature=-crt-static -C unsafe-allow-abi-mismatch=sanitizer -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
