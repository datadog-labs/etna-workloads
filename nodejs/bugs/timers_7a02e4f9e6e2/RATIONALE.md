# timers: do not retain a reference to the async store after firing

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7a02e4f9e6e2c1abe1a6162421f0e5450aabff54 applied to v26.13.0 (clean).

Upstream commit message:

```
timers: do not retain a reference to the async store after firing

After firing timers, we can clean them up by iterating over all active
stores and setting the relevant symbols to undefined.

Fixes #53408

Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/53443
Reviewed-By: Stephen Belanger <admin@stephenbelanger.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
```
