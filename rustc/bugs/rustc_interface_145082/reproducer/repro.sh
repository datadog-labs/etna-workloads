#!/bin/bash
"$RUSTC" --crate-type=lib -Zmacro-stats main.rs 2>&1
echo "status $?"
