#!/bin/bash
# Auto-generated from tests/ui/sanitizer/cfi/with-rustc-lto-requires-single-codegen-unit.rs
cd "$(dirname "$0")"
"$RUSTC" -Ccodegen-units=2 -Clto -Ctarget-feature=-crt-static -Zsanitizer=cfi --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
