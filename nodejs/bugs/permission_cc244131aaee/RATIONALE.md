# permission: check permission model in realpathSync

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cc244131aaeef774effdc94b59a8a2de84a2d262 applied to v26.13.0 (clean).

Upstream commit message:

```
permission: check permission model in realpathSync

The equivalent entry points (fs.realpathSync.native(),
fs.promises.realpath(), fs.lstatSync(), fs.existsSync())
already deny access for the same paths

Signed-off-by: RafaelGSS <rafael.nunu@hotmail.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/973
Refs: https://hackerone.com/reports/3838675
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
CVE-ID: CVE-2026-106073
```
