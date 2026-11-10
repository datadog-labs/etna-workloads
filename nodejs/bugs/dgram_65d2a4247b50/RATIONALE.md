# dgram: fix unhandled exception aborting a closed udp socket

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 65d2a4247b50bf769e9f6a380bfd1c14d25ede2a applied to v26.13.0 (clean).

Upstream commit message:

```
dgram: fix unhandled exception aborting a closed udp socket

Fixes: https://github.com/nodejs/node/issues/46750
PR-URL: https://github.com/nodejs/node/pull/46770
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
