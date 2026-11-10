#!/bin/bash
# Auto-generated from tests/ui/higher-ranked/leak-check/candidate-from-env-universe-err-1.rs#old
cd "$(dirname "$0")"
"$RUSTC" --cfg old --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
