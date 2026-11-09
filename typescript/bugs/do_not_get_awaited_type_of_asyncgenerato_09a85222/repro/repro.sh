#!/bin/bash
node "$TSC" --target esnext --strict --noEmit --lib esnext input.ts
echo "exit $?"
