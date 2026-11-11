#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 -Z mir-enable-passes=+Inline -Z validate-mir -C opt-level=1 main.rs -o out.rlib 2>&1 | grep -E "internal compiler error|Cannot Eq|^error" | sed 's/DefId.*)) /ITEM /'
echo "status ${PIPESTATUS[0]}"
