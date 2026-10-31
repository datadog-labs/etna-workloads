Spawns a child running deeply nested oscillating generators (from the upstream test), samples it
with `_remote_debugging.RemoteUnwinder(cache_frames=True)` for 3s, and checks that every stack's
outermost frame is `<module>`.
Clean: "incomplete stacks seen: False". Buggy: "True" — the frame cache stores incomplete stacks
(missing base-frame validation), so some samples lack the entry point.
