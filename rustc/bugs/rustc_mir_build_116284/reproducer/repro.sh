#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-1445-restrict-constants-in-patterns/issue-6804-nan-match.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
