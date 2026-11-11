#!/bin/bash
$RUSTC --crate-type proc-macro --crate-name pm pm.rs --edition 2021 2>&1
$RUSTC main.rs --edition 2021 --extern pm=libpm.so -Z span-debug 2>&1 | sed 's/(#[0-9]*)//'
echo "status ${PIPESTATUS[0]}"
