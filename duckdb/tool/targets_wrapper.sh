#!/bin/bash
# Used as the Makefile's NINJA_BUILD_WRAPPER: `cmake --build . --config X` -> only the targets we test with.
exec "$@" --target unittest --target shell
