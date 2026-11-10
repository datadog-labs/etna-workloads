#!/bin/bash
node "$TSC" --noEmit --declaration --strict input.ts
echo "exit: $?"
