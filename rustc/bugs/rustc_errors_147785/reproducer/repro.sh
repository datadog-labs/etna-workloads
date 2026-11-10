#!/bin/bash
# Auto-generated from tests/ui/error-emitter/trimmed_multiline_suggestion.rs
cd "$(dirname "$0")"
"$RUSTC" -Z ui-testing=no --diagnostic-width=80 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
