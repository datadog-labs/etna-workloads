#!/bin/bash
node "$TSC" -p tsconfig.json --explainFiles --noLib 2>&1 | grep -v "^error TS2318"
