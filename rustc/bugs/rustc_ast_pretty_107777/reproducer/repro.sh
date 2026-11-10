#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -Zunpretty=normal main.rs 2>&1
echo "status $?"
