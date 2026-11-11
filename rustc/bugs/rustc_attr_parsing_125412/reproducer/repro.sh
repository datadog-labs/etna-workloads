#!/bin/bash
export CARGO_CRATE_NAME=build_script_build
"$RUSTC" --crate-name build_script_build --crate-type bin --emit=metadata --check-cfg 'cfg()' main.rs 2>&1
echo "exit=$?"
