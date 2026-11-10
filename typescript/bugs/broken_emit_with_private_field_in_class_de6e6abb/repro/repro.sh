#!/bin/bash
node "$TSC" --noEmit --target esnext --strict false input.ts
echo "exit $?"
