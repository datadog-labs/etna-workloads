#!/bin/bash
"$RUSTC" --crate-type lib --emit metadata -o out.rmeta --check-cfg='cfg(docsrs)' main.rs 2>&1
echo "status $?"
