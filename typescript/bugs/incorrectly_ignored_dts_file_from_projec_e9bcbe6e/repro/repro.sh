#!/bin/bash
node "$TSC" -b consumer 2>&1
echo "exit: $?"
