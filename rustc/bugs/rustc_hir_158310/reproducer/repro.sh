#!/bin/bash
{ "$RUSTC" --edition 2021 --crate-type bin --emit metadata -A incomplete_features -A internal_features main.rs >/dev/null 2>&1; } 2>/dev/null
st=$?
echo "status=$st"
