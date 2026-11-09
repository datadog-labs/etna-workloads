#!/bin/bash
node "$TSC" --noEmit --jsx preserve --target esnext input.tsx
echo "exit $?"
