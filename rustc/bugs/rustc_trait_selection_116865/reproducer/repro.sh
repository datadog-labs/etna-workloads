#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --color never main.rs 2>&1 | sed 's/^\( *-->\).*/\1 main.rs/'
