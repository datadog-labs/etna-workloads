#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -Copt-level=3 -Zinline-mir -Cpanic=abort --emit=mir -o out.mir main.rs 2>&1
sed -n '/fn call/,/^}/p' out.mir | grep -E 'type_id|inlined' | sed 's/^ *//'
