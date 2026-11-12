"""Parse `git log --no-merges` with changed file names into records."""
import subprocess

SEP = "\x1e"


def log_records(repo, rev, extra=()):
    fmt = SEP + "%H%x1f%P%x1f%ct%x1f%an%x1f%s%x1f%b%x1d"
    out = subprocess.run(
        ["git", "-C", repo, "log", "--no-merges", "--no-renames", "--name-only",
         "--format=" + fmt, *extra, rev],
        check=True, capture_output=True).stdout.decode("utf-8", "replace")
    for chunk in out.split(SEP)[1:]:
        head, _, files = chunk.partition("\x1d")
        h, parents, ct, an, subj, body = head.split("\x1f")
        yield dict(sha=h, parents=parents.split(), time=int(ct), author=an,
                   subject=subj, body=body.strip(),
                   files=[f for f in files.strip().splitlines() if f])
