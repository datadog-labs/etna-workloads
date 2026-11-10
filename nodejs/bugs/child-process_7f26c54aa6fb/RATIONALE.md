# child_process: fix permission model propagation via NODE_OPTIONS

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7f26c54aa6fbacfbe2e0ae56b6e058f5be335e65 applied to v26.13.0 (clean).

Upstream commit message:

```
child_process: fix permission model propagation via NODE_OPTIONS

The substring check env[key].indexOf(--permission) !== -1 in
copyPermissionModelFlagsToEnv falsely treats unrelated NODE_OPTIONS
values like --title=--permission as if the child already has an
explicit Permission Model policy. This prevents flag propagation,
causing the child to run without process.permission.

Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/63972
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
