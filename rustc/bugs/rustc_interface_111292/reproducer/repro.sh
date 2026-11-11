#!/bin/bash
for order in 1 2; do
  if [ $order = 1 ]; then A='--check-cfg=cfg(a,values("b")) --check-cfg=cfg(a)'; else A='--check-cfg=cfg(a) --check-cfg=cfg(a,values("b"))'; fi
  echo "== order $order"
  "$RUSTC" --edition 2021 --crate-type lib --emit metadata -o out.rmeta main.rs $A 2>&1
  echo "status $?"
done
