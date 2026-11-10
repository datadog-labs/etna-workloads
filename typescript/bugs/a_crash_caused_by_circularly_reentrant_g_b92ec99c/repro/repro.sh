#!/bin/bash
node "$TSC" --strict --noEmit input.ts
echo "exit $?"
