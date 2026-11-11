#!/bin/bash
# Auto-generated from tests/ui/lang-items/start_lang_item_with_target_feature.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
