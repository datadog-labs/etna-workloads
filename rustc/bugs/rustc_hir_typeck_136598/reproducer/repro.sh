#!/bin/bash
# Auto-generated from tests/ui/never_type/fallback_change/lint-never-type-fallback-flowing-into-unsafe.rs#e2015
cd "$(dirname "$0")"
"$RUSTC" --cfg e2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
