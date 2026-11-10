#!/bin/bash
# Auto-generated from tests/ui/resolve/resolve-issue-135614-assoc-const.rs#import_trait_associated_functions
cd "$(dirname "$0")"
"$RUSTC" --cfg import_trait_associated_functions -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
