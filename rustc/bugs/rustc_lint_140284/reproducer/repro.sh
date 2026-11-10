#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --crate-name zerocopy --remap-path-prefix=/=/non-existent "$PWD/aux.rs" 2>&1
"$RUSTC" --edition 2021 --crate-type lib --emit metadata --extern zerocopy=libzerocopy.rlib main.rs 2>&1 | grep -v '^ *[0-9]*:' | sed 's/thread .*panicked/panicked/;s/[A-Za-z0-9_\/.-]*\/transmute.rs/transmute.rs/' | head -3
echo "status=${PIPESTATUS[0]}"
