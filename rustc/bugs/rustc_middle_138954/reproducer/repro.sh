#!/bin/bash
for rev in rpass1 bfail2; do
  "$RUSTC" main.rs --cfg $rev --crate-type lib -C incremental=inc -Z incremental-verify-ich -A unused 2>&1
  echo "$rev exit=$?"
done
