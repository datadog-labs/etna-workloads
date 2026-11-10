#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib dep.rs 2>&1
"$RUSTC" --edition 2021 --crate-type lib --extern dep=libdep.rlib main.rs 2>&1
echo "status $?"
