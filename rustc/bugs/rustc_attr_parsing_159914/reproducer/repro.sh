#!/bin/bash
# Auto-generated from tests/ui/diagnostic_namespace/on_unmatched_args/disabled-feature-issue-159886.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
