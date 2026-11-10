#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target esnext a.js
echo "exit $?"
