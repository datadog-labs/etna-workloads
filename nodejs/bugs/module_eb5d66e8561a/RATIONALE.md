# module: report unreadable package.json

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit eb5d66e8561acaadfe37bff7b696175ecf1ed4c8 applied to v26.13.0 (clean).

Upstream commit message:

```
module: report unreadable package.json

A package.json that exists but cannot be read was treated the same as
one that is not there: the read failure returned no config and
resolution continued as if the package had none. Fields such as
"exports" and "type" silently disappear, so a specifier can resolve to
a different file than the package declares, while an unparsable
package.json already throws ERR_INVALID_PACKAGE_CONFIG.

Keep treating ENOENT and ENOTDIR as "no package config here", and
report any other read failure with the underlying error.

Fixes: https://github.com/nodejs/node/issues/65220
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/65223
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
