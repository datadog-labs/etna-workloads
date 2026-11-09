Builds an incremental project whose only input `a.ts` is an empty file, then bumps a.ts's mtime (content unchanged) and runs `tsc -b -v`.
Clean: treats the empty file's hash as a valid version -> "up to date but needs to update timestamps".
Injected: empty text is falsy so the version is lost -> "out of date because output ... is older than input" (would rebuild).
