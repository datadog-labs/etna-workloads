#!/bin/bash
node "$TSC" --noEmit --strict --target es2015 --lib esnext input.ts
echo "exit: $?"
