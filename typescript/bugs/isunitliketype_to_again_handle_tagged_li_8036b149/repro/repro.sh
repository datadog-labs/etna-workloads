#!/bin/bash
node "$TSC" --noEmit --strict input.ts
echo "exit: $?"
