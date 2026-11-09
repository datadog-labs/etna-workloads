#!/bin/bash
node "$TSC" --noEmit --pretty false input.ts
echo "exit $?"
