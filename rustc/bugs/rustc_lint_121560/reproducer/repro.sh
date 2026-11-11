#!/bin/bash
# Auto-generated from tests/ui/lint/deny-inside-forbid-ignored.rs#cli_forbid
cd "$(dirname "$0")"
"$RUSTC" -F unsafe_code --cfg cli_forbid -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
