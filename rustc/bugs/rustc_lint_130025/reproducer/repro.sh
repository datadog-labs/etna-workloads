#!/bin/bash
# Auto-generated from tests/ui/lint/lint-missing-doc-expect.rs#test_
cd "$(dirname "$0")"
"$RUSTC" --test --cfg test_ --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
