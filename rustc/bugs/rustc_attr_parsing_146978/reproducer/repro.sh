#!/bin/bash
# Auto-generated from tests/ui/cfg/path-kw-as-cfg-pred-cli-cfg.rs#cfg_crate
cd "$(dirname "$0")"
"$RUSTC" --cfg crate --edition 2024 --cfg cfg_crate -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
