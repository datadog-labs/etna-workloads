# test_runner: match dotfiles in default coverage exclude

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4de7e638836ba13e5b0856c5cab9097a47b5b779 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: match dotfiles in default coverage exclude

The default coverage exclude globs did not match dotfiles, so test
files such as `test/.foo.test.js` were incorrectly included in coverage
reports. Apply the `dot: true` minimatch option when matching the
relative path so the default exclude patterns cover dotfiles, while
keeping plain matching for the absolute path to avoid misinterpreting
dot segments in the filesystem path (e.g. tmp dirs like `test/.tmp.0`).

Fixes: https://github.com/nodejs/node/issues/63397
Signed-off-by: semimikoh <ejffjeosms@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63401
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
```
