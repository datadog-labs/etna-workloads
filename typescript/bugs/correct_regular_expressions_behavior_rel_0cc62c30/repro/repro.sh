#!/bin/bash
node "$TSC" --noEmit --target esnext input.ts
echo "exit $?"
