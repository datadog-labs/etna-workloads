#!/bin/bash
"$RUSTC" --edition=2018 --emit=metadata --crate-type=bin -Afor_loops_over_fallibles -Warray_into_iter main.rs -o out.rmeta 2>&1 | grep -E "^(warning|error)|panicked|must not be empty" | sed 's/(#[0-9]*)//'
echo "status: ${PIPESTATUS[0]}"
