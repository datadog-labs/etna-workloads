#!/bin/bash
# Auto-generated from tests/ui/asm/global-asm-isnt-really-a-mir-body.rs#emit_mir
cd "$(dirname "$0")"
"$RUSTC" -C unsafe-allow-abi-mismatch=sanitizer --emit=mir --cfg emit_mir -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
