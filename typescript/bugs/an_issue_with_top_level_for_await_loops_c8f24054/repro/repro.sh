#!/bin/bash
node "$TSC" --module preserve --target esnext --noEmit input.ts
echo "exit: $?"
