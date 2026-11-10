#!/bin/bash
node "$TSC" --strict --target esnext --noEmit input.ts
echo "exit $?"
