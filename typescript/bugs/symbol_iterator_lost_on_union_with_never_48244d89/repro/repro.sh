#!/bin/bash
node "$TSC" --noEmit --strict --target esnext input.ts
echo "exit $?"
