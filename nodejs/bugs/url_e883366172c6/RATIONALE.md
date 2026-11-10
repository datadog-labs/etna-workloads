# url: fix URLSearchParams(null) to prudce null= per spec

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e883366172c658ad9ac553519523b614dd0512c1 applied to v26.13.0 (clean).

Upstream commit message:

```
url: fix URLSearchParams(null) to prudce null= per spec

Signed-off-by: marcopiraccini <marco.piraccini@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63782
Fixes: https://github.com/nodejs/node/issues/63559
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
Reviewed-By: Daijiro Wachi <daijiro.wachi@gmail.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
