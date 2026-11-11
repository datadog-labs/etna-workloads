#!/bin/bash
unset RUST_BACKTRACE
"$RUSTC" --edition 2021 -Zui-testing -Ztreat-err-as-bug=1 --emit=metadata -o out.rmeta main.rs >out.txt 2>&1
echo "exit: $?"
echo "short-backtrace note: $(grep -c 'omitted .* frames' out.txt)"
echo "full-backtrace markers: $(grep -c 'begin_short_backtrace' out.txt)"
