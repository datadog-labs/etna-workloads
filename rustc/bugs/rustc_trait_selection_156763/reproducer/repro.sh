#!/bin/bash
export RUSTC_BOOTSTRAP=1
$RUSTC --edition 2024 --crate-type proc-macro proc_macro_repro.rs --crate-name proc_macro_repro -o libproc_macro_repro.so 2>&1
$RUSTC --edition 2024 --crate-type lib main.rs --extern proc_macro_repro=libproc_macro_repro.so --error-format short 2>&1
echo "exit $?"
$RUSTC --edition 2024 --crate-type lib main.rs --extern proc_macro_repro=libproc_macro_repro.so 2>&1 | grep -c 'originates in the attribute macro'
