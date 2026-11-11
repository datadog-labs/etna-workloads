#!/bin/bash
# Auto-generated from tests/ui/dst/issue-90528-unsizing-not-suggestion-110063.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
