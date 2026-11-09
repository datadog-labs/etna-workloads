#!/bin/bash
node "$TSC" --noEmit --allowJs --checkJs --target esnext input.js
echo "exit $?"
