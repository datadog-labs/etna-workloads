#!/bin/bash
# Auto-generated from tests/ui/lint/unused/issue-119383-if-let-guard.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
