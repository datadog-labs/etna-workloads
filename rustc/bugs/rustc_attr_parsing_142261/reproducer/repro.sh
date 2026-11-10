#!/bin/bash
# Auto-generated from tests/ui/editions/unsafe-attr-edition-span.rs#e2015
cd "$(dirname "$0")"
"$RUSTC" --cfg e2015 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
