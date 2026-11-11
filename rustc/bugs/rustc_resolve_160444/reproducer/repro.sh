#!/bin/bash
# Auto-generated from tests/ui/resolve/macro-determinacy-non-module-issue-160195.rs#env_second
cd "$(dirname "$0")"
"$RUSTC" --cfg env_second -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
