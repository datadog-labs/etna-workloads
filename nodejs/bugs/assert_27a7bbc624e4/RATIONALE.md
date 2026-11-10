# assert: fix loose deepEqual arrays with undefined and null failing

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 27a7bbc624e4751ca53cd8736336f1ed78cbd1ca applied to v26.13.0 (clean).

Upstream commit message:

```
assert: fix loose deepEqual arrays with undefined and null failing

The comparison has to accept these as identical.

Fixes: https://github.com/nodejs/node/issues/61583
PR-URL: https://github.com/nodejs/node/pull/61587
Reviewed-By: Jithil P Ponnan <jithil@outlook.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: Ulises Gascón <ulisesgascongonzalez@gmail.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
```
