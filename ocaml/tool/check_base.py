"""Check that the base source and every slot snapshot still match the pristine release
(git blob hashes of every tracked, non-symlink file).  usage: check_base.py [dirs...]"""
import subprocess, sys
from pathlib import Path
from common import *


def release_blobs():
    out = git("ls-tree", "-r", "-z", RELEASE)
    blobs = {}
    for rec in out.split("\0"):
        if not rec:
            continue
        meta, path = rec.split("\t", 1)
        mode, typ, sha = meta.split()
        if typ == "blob" and mode != "120000":
            blobs[path] = sha
    return blobs


def check(root, blobs):
    root = Path(root)
    paths = sorted(blobs)
    present = [p for p in paths if (root / p).is_file()]
    missing = [p for p in paths if not (root / p).is_file()]
    r = subprocess.run(["git", "hash-object", "--no-filters", "--stdin-paths"], cwd=root,
                       input="\n".join(present) + "\n", capture_output=True, text=True, check=True)
    hashes = r.stdout.split()
    diff = [p for p, h in zip(present, hashes) if h != blobs[p]]
    # files with eol=crlf in .gitattributes are converted at checkout: compare normalised
    real = []
    for p in diff:
        data = (root / p).read_bytes().replace(b"\r\n", b"\n")
        h = subprocess.run(["git", "hash-object", "--no-filters", "--stdin"], input=data,
                           capture_output=True, check=True).stdout.decode().strip()
        if h != blobs[p]:
            real.append(p)
    return missing, real


if __name__ == "__main__":
    blobs = release_blobs()
    dirs = sys.argv[1:] or [str(WORK / "release-src")] + sorted(str(p) for p in (WORK / "slots").glob("s*/snap"))
    bad = 0
    for d in dirs:
        m, df = check(d, blobs)
        print(f"{d}: {len(blobs)} tracked, missing {len(m)} {m[:3]}, modified {len(df)} {df[:5]}")
        bad += len(m) + len(df)
    sys.exit(1 if bad else 0)
