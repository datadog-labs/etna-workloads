#!/bin/bash
# Auto-generated from tests/ui/pattern/no-match-tuple-variant-self-ctor.rs#struct_
cd "$(dirname "$0")"
"$RUSTC" --cfg struct_ -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
