#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target esnext --strict false a.js
echo "exit: $?"
