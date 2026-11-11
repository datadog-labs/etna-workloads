#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/deferred-closure-call-recovery-issue-157951.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
