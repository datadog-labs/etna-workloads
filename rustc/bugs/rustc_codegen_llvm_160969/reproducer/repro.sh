#!/bin/bash
for d in 0 2; do
  echo "== debuginfo=$d"
  "$RUSTC" main.rs --crate-type lib --emit=obj -o out.o -Cdebuginfo=$d -Adead_code --error-format=human 2>&1
  echo "exit=$?"
done
