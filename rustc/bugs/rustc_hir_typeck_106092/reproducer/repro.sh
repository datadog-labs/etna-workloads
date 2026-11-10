#!/bin/bash
# Auto-generated from tests/ui/lang-items/start_lang_item_args.rs#argc
cd "$(dirname "$0")"
"$RUSTC" --cfg argc --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
