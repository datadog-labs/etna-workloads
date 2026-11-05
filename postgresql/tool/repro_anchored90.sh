#!/bin/sh
# Keep w6,w7 busy: reproducers for adapted bugs whose anchor is exact, refreshing the list while anchors run.
T=$(cd "$(dirname "$0")" && pwd)
W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
while ps -eo args | grep -q '^python3 .*/anchor.py'; do
  python3 -c "
import json,glob
json.dump([json.load(open(p))['commit'] for p in glob.glob('state/anchor/*.json') if json.load(open(p))['status']=='exact'], open('state/anchored_exact.json','w'))"
  python3 "$T"/repro.py --cap 90 --workers w6,w7 --filter state/anchored_exact.json >> logs/repro.out 2>&1
  sleep 600
done
