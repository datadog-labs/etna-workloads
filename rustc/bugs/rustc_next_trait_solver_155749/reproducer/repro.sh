#!/bin/bash
# Auto-generated from tests/ui/higher-ranked/leak-check/candidate-from-env-universe-err-project.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg next -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
