#!/bin/bash
$RUSTC --crate-type proc-macro --crate-name match_expander match_expander.rs 2>&1
$RUSTC --edition 2021 --emit metadata --extern match_expander=libmatch_expander.so main.rs 2>&1
echo "status $?"
