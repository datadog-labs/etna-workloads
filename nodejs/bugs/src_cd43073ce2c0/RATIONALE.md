# src: fix multiple AddLinkedBinding() calls

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cd43073ce2c0c89498e37b4db6161a56fccd1fff applied to v26.13.0 (fuzzy).

Upstream commit message:

```
src: fix multiple AddLinkedBinding() calls

Singly-linked lists are extended at their tail, not their head.
This fixes using more than 2 linked addons at a time.

PR-URL: https://github.com/nodejs/node/pull/39012
Reviewed-By: Shelley Vohr <codebytere@gmail.com>
Reviewed-By: Michaël Zasso <targos@protonmail.com>
Reviewed-By: Richard Lau <rlau@redhat.com>
```
