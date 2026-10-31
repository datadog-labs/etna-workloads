Reproducer calls `_pyrepl.utils.gen_colors` on `a.set`, `obj.list` and a backslash-continued `b. \ format`, and prints the color tags.
Clean: attribute names after a dot get no highlight (`['op']`). Buggy: the attribute is wrongly tagged as `builtin` (`['op', 'builtin']`).
