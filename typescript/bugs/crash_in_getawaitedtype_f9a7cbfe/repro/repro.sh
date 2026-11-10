#!/bin/bash
node "$TSC" --target esnext --noEmit --lib esnext input.ts
echo "exit $?"
