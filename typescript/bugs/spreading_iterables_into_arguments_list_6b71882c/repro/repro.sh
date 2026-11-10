#!/bin/bash
node "$TSC" --noEmit --target esnext --strict input.ts
echo "exit $?"
