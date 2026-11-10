#!/bin/bash
# Set up the rustc 1.99.1 release tree and build the stage-1 compiler + std.
# usage: bin/setup.sh DIR
# Needs: git, python3, a C toolchain, network (stage0 toolchain + CI LLVM download).
# If CI LLVM for 1.99.1 is no longer downloadable, rerun with ETNA_BUILD_LLVM=1 to build
# LLVM from the src/llvm-project submodule (slow).
set -eu
DIR=${1:?usage: setup.sh DIR}
HERE=$(cd "$(dirname "$0")/.." && pwd)
if [ ! -d "$DIR/.git" ]; then
  git clone --filter=blob:none --no-checkout https://github.com/rust-lang/rust.git "$DIR"
  git -C "$DIR" checkout -q --detach 1.99.1
fi
[ "$(git -C "$DIR" rev-parse HEAD)" = 58cf8f9c35b355199727627d07ae34a4e2846d67 ] || { echo "not at 1.99.1"; exit 1; }
cp "$HERE/bin/bootstrap.toml" "$DIR/bootstrap.toml"
if [ "${ETNA_BUILD_LLVM:-0}" = 1 ]; then
  sed -i 's/^download-ci-llvm = true/download-ci-llvm = false/' "$DIR/bootstrap.toml"
fi
cd "$DIR" && ./x build --stage 1 library
