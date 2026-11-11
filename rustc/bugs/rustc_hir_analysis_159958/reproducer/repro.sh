#!/bin/bash
# Auto-generated from tests/ui/associated-type-bounds/return-type-notation/nested-rtn-error-recovery-issue-133613.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
