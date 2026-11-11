#!/bin/bash
$RUSTC --edition=2021 --crate-type=lib --crate-name async_drop_dep dep.rs -A warnings 2>&1 | head -5
$RUSTC --edition=2021 --extern async_drop_dep=libasync_drop_dep.rlib main.rs -A warnings 2>&1 | grep -E "panicked|isn't local|error" | sed 's/thread .* panicked/panicked/'
echo "status: ${PIPESTATUS[0]}"
[ -x ./main ] && ./main
