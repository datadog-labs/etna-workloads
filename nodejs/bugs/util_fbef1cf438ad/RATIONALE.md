# util: fix stylize of special properties in inspect

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fbef1cf438ad27ce04d679aa3384e5e291d20474 applied to v26.13.0 (clean).

Upstream commit message:

```
util: fix stylize of special properties in inspect

Previously, formatExtraProperties applied ctx.stylize to the entire
'[key]: value' string. This caused the colon and space to be styled,
making the output inconsistent with normal object properties.

Now, only the key itself is stylized, and the colon and space remain
unstyled, aligning with the formatting of regular properties.

Refs: https://github.com/nodejs/node/pull/60131
PR-URL: https://github.com/nodejs/node/pull/60479
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
