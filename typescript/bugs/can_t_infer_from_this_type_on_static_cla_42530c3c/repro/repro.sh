#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --strict --target es2015 input.js
echo "exit $?"
