#!/bin/bash
# Auto-generated from tests/ui/diagnostic_namespace/do_not_recommend/does_not_acccept_args.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
