#!/bin/bash
$RUSTC --crate-type lib --crate-name cfg_macro lib.rs -o libcfg_macro.rlib 2>&1
$RUSTC --edition 2021 --crate-type bin main.rs --extern cfg_macro=libcfg_macro.rlib --check-cfg='cfg(feature,values())' --emit=metadata -o main.out 2>&1
echo "status $?"
