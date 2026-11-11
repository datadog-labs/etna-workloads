#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2294-if-let-guard/scope.rs#edition2021
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg edition2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
