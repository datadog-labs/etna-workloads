#!/bin/bash
node "$TSC" --target esnext --noEmit false --outFile /dev/stdout input.ts
echo "exit=$?"
