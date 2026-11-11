#!/bin/bash
# Auto-generated from tests/ui/assumptions_on_binders/canonical-response-placeholder-assumptions-issue-159889.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -Zassumptions-on-binders -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
