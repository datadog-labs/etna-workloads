#!/bin/bash
node "$TSC" --allowJs --checkJs --strict --noEmit --target es2015 a.js
echo "exit: $?"
