#!/bin/bash
# Auto-generated from tests/ui/lint/improper-ctypes/async-extern-fn-next-solver-issue-156352.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally --edition 2021 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
