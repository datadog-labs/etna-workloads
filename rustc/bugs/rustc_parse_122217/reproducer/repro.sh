#!/bin/bash
# Auto-generated from tests/ui/lexer/lex-bad-str-literal-as-char-3.rs#rust2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg rust2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
