#!/bin/bash
node "$TSC" --strict --noEmit --noUnusedLocals --noUnusedParameters input.ts; echo "exit $?"
