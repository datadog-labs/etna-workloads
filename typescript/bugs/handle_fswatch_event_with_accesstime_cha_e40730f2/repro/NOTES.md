The script fakes `process.platform = "darwin"` (the only platform where fsWatchWithTimestamp is on), then uses `ts.sys.watchFile` with UseFsEvents on a file and changes only its access time (mtime untouched).
Clean: the fs event is filtered because the modified time is unchanged, so no callback fires (`[]`).
Injected: the timestamp-handling wrapper is gone, so a spurious change callback fires (`[1]`).
