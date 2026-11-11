#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_exprs/trivial-anon-const-use-cases.rs#min
cd "$(dirname "$0")"
"$RUSTC" --cfg min -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
