#!/bin/bash
# Auto-generated from tests/ui/sanitizer/cfi/assoc-const-projection-issue-151878.rs
cd "$(dirname "$0")"
"$RUSTC" -Zsanitizer=cfi -Cunsafe-allow-abi-mismatch=sanitizer -Ccodegen-units=1 -Clto -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
