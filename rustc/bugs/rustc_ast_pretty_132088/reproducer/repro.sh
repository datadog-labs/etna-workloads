#!/bin/bash
"$RUSTC" --edition 2021 -Zunpretty=normal main.rs 2>&1
echo "status $?"
