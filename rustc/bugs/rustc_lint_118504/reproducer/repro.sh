#!/bin/bash
# Auto-generated from tests/ui/lint/unused/assoc-types.rs#assoc_ty
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg assoc_ty -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
