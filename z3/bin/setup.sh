#!/bin/bash
# Fetch the z3-5.3.3 release into $SRC (default ./z3-src), link Marauders config, configure and build.
source "$(dirname "$0")/common.sh"
if [ ! -d "$SRC/.git" ]; then
  git clone --quiet --branch "$RELEASE_TAG" --depth 1 https://github.com/Z3Prover/z3.git "$SRC"
fi
[ "$(git -C "$SRC" rev-parse HEAD)" = "$RELEASE_SHA" ] || { echo "unexpected release commit" >&2; exit 1; }
ln -sfn "$ROOT/patches" "$SRC/patches"
ln -sfn "$ROOT/marauder.toml" "$SRC/marauder.toml"
grep -qx 'build-etna/' "$SRC/.git/info/exclude" 2>/dev/null || printf 'build-etna/\npatches\nmarauder.toml\n.marauders/\n' >> "$SRC/.git/info/exclude"
cmake -S "$SRC" -B "$BUILD" -G Ninja -DCMAKE_BUILD_TYPE=Debug "-DCMAKE_CXX_FLAGS_DEBUG=-O1 -g0" \
  -DZ3_INCLUDE_GIT_HASH=OFF -DZ3_INCLUDE_GIT_DESCRIBE=OFF -DZ3_BUILD_TEST_EXECUTABLES=ON > /dev/null
"$ROOT/bin/build.sh"
