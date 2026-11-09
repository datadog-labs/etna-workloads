#!/bin/bash
node "$TSC" --strict --target esnext --lib esnext --noEmit input.ts
echo "exit $?"
