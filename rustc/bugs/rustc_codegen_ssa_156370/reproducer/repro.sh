#!/bin/bash
"$RUSTC" --edition 2021 --crate-type dylib -C prefer-dynamic dylib_default.rs -A warnings 2>&1; echo "aux status $?"
"$RUSTC" --edition 2021 main.rs --emit link -C prefer-dynamic -L . 2>&1; echo "status $?"
