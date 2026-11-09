#!/bin/bash
node "$TSC" --allowJs --checkJs --outDir out --target es2015 a.js b.js 2>&1 | grep -v '^    at ' | grep -E "^(a|b)\.js|Debug Failure"
echo "exit ${PIPESTATUS[0]}"
