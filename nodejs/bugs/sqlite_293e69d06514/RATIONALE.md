# sqlite: throw on invalid URL path instead of abort

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 293e69d06514733a611b791c73a75fadbe905a3e applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: throw on invalid URL path instead of abort

ValidateDatabasePath() treats any object exposing a string `href` as a
URL, then asserts the parse result with CHECK(ada::can_parse(location)).
Whether that string parses depends on user input rather than on an
invariant the code guarantees, so a value such as { href: 'not a url' }
aborted the process instead of throwing.

Replace the CHECK with an ERR_INVALID_URL exception, matching how
node_file.cc reports an unparsable URL. Both DatabaseSync() and backup()
validate their path through this function, so both paths are covered.

Signed-off-by: Guilherme Araújo <arauujogui@gmail.com>
Assisted-by: Claude Code
PR-URL: https://github.com/nodejs/node/pull/66026
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Edy Silva <edigleyssonsilva@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
