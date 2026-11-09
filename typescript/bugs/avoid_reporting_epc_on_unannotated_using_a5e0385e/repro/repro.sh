#!/bin/bash
node "$TSC" --strict --target esnext --module esnext --lib esnext --noEmit input.ts
echo "exit: $?"
