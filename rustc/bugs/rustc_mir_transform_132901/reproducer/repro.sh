#!/bin/bash
# Auto-generated from tests/ui/mir/enable_passes_validation.rs#all_unknown
cd "$(dirname "$0")"
"$RUSTC" -Zmir-enable-passes=+ThisPass,-DoesNotExist --cfg all_unknown --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
