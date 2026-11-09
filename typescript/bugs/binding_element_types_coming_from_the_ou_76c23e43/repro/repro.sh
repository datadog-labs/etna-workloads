#!/bin/bash
node "$TSC" --noEmit --strict --noUncheckedIndexedAccess --target es2015 input.ts
echo "exit: $?"
