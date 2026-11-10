#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 rpitit.rs --emit metadata,link 2>&1
echo "lib status: $?"
"$RUSTC" --edition 2021 main.rs --emit metadata -L . 2>&1 | grep -E '^error|panicked|def_span' | sed 's/(.*)//'
echo "status: ${PIPESTATUS[0]}"
