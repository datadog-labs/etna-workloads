# Re-introduced bug: fs.mkdir recursive on a file loses `path` in the ENOTDIR error

**Bug.** `fs.mkdir(p, {recursive: true})` where a path component is a regular file fails with ENOTDIR, but the error had no `path` property (nodejs/node#28015). `ENOTDIR` was not handled as a terminal error in MKDirp. It fell through to the `default:` stat branch. In the async stat callback the request was cleaned up (`uv_fs_req_cleanup`) before `Done(err)`, which wiped `req->path`.

**Hunks (all in `src/node_file.cc`)**
1. `MKDirpSync`: removed `case UV_ENOTDIR:` from the terminal-error group. This is the reverse of the fix's first hunk. ENOTDIR goes back through the default stat path.
2. `MKDirpAsync`: removed `case UV_ENOTDIR:` from the terminal-error group. This is the reverse of the fix's second hunk.
3. `MKDirpAsync` stat callback: re-added `uv_fs_req_cleanup(req);` before `Done(err)`. This is the reverse of the fix's third hunk, which deleted that line. It clears `req->path`, so the async error has no `path`.

**Failing test.** `parallel/test-fs-mkdir` fails, and it fails stably (run twice). The message is:
`test-fs-mkdir.js:215 assert(err.path.startsWith(filename)); TypeError: Cannot read properties of undefined (reading 'startsWith')`
