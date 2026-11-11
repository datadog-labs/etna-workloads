#!/bin/bash
# Auto-generated from tests/ui/did_you_mean/bad-assoc-ty.rs#edition2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg edition2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
