#!/bin/sh
# Set up PostgreSQL REL_18_6 for this workload: clone, verify, configure (as used for the dataset), build.
# usage: bin/setup.sh [DIR]   (default: ./postgres next to this workload)
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd)
DIR=${1:-$HERE/postgres}
REL=REL_18_6; SHA=724edf9bde9d356724ad384a2e196edc3c9f80f7
if [ ! -d "$DIR/.git" ]; then
  git clone --quiet --depth 1 --branch "$REL" https://github.com/postgres/postgres.git "$DIR"
fi
[ "$(git -C "$DIR" rev-parse HEAD)" = "$SHA" ] || { echo "unexpected revision in $DIR" >&2; exit 1; }
# Marauders project root = the PostgreSQL checkout (patch paths are relative to it)
ln -sfn "$HERE/patches" "$DIR/patches"
cp "$HERE/marauder.toml" "$DIR/marauder.toml"
grep -qx 'patches' "$DIR/.git/info/exclude" 2>/dev/null || printf 'patches\nmarauder.toml\n.marauders/\n.etna/\n' >> "$DIR/.git/info/exclude"
cd "$DIR"
if [ ! -f config.status ]; then
  ./configure --silent --enable-cassert --enable-debug --enable-depend --enable-injection-points \
    --enable-tap-tests --with-python --with-tcl --with-libxml --with-libxslt --with-lz4 --with-icu \
    --with-openssl --with-uuid=e2fs PYTHON=${PYTHON:-$( [ -x /usr/bin/python3 ] && echo /usr/bin/python3 || echo python3 )}
fi
make -s -j"$(nproc)" >/dev/null
make -s -j"$(nproc)" -C src/test/modules >/dev/null
echo "ready: $DIR"
