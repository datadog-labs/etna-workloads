#!/bin/bash
# Auto-generated from tests/ui/compile-flags/jobs/jobs-pass-link.rs
cd "$(dirname "$0")"
"$RUSTC" -Z unstable-options --jobs-linker 2 --jobs-backend 1 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
