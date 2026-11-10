#!/bin/bash
# Auto-generated from tests/ui/lifetimes/no-lt-elision-in-variant-path-seg-as-enum-path-seg-has-gen-args.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
