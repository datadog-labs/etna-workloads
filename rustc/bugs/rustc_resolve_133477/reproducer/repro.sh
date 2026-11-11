#!/bin/bash
"$RUSTC" --edition 2021 main.rs -o out 2>&1
echo "status=$?"
