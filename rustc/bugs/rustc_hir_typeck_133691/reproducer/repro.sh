#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -D dependency_on_unit_never_type_fallback main.rs 2>&1
echo "status $?"
