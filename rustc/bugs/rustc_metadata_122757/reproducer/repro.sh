#!/bin/bash
mkdir -p out
"$RUSTC" --edition 2021 --crate-type rlib --crate-name foo foo.rs --out-dir out 2>&1; echo "foo: $?"
"$RUSTC" --edition 2021 --crate-type rlib --crate-name bar bar.rs --out-dir out -Zunstable-options --extern priv:foo=out/libfoo.rlib 2>&1; echo "bar: $?"
"$RUSTC" --edition 2021 --crate-type rlib --crate-name main main.rs --out-dir out -L out 2>&1 | sed 's#--> .*/#--> #'; echo "main: ${PIPESTATUS[0]}"
