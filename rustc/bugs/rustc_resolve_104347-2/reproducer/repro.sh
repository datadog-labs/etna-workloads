#!/bin/bash
"$RUSTC" --edition 2018 --crate-type lib --error-format human --color never main.rs 2>&1
echo "exit $?"
