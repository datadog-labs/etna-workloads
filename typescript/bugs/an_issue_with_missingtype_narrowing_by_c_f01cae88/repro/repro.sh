#!/bin/bash
node "$TSC" --strict --exactOptionalPropertyTypes --noEmit --target es2015 input.ts
echo "exit: $?"
