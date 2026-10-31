Builds PurePosixPath('b/', 'c:\\d') and wraps it in PureWindowsPath (GH-125069).
Clean: PureWindowsPath('b/c:/d') (uses as_posix()). Buggy: raw segments are re-joined
by the Windows flavour, giving a different path (drive-relative 'c:\\d' replaces 'b/').
