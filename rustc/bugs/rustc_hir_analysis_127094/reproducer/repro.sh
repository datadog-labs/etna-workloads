#!/bin/bash
# Auto-generated from tests/ui/errors/dynless-turbofish-e0191-issue-91997.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
