#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/allow-or-expect-dead_code-114557.rs#expect
cd "$(dirname "$0")"
"$RUSTC" --cfg expect --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
