#!/bin/bash
node "$TSC" --strict --noEmit --pretty false input.ts
echo "exit $?"
