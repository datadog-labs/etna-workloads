#!/bin/bash
# Run every oracle suite twice on the base build; logs in ~/rustc-etna-work/runs/.
set -u
cd ~/rustc-etna-work/base
SUITES="tests/ui tests/crashes tests/mir-opt tests/codegen-llvm tests/codegen-units tests/incremental tests/assembly-llvm"
for i in 1 2; do
  /usr/bin/time -f "run $i: %e s" ./x test --stage 1 --keep-stage-std 1 --force-rerun --no-fail-fast $SUITES \
    > ~/rustc-etna-work/runs/base-$i.log 2>&1
  echo "exit $?" >> ~/rustc-etna-work/runs/base-$i.log
done
