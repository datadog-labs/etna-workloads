#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2294-if-let-guard/drop-scope.rs#edition2021
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg edition2021 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
