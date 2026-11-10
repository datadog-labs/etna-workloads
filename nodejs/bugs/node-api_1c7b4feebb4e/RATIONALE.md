# node-api: do not crash on module version mismatch

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1c7b4feebb4e81cab4bb9a1c4b25ba101970afe7 applied to v26.13.0 (clean).

Upstream commit message:

```
node-api: do not crash on module version mismatch

`node_napi_env__::New()` returns nullptr after throwing when an add-on
declares a Node-API version this binary does not support, but
`napi_module_register_by_symbol()` dereferenced the result without
checking it. Loading such an add-on segfaulted instead of surfacing the
error the version check had already produced, so `require()` could not
catch it.

Reproduced on v20.x, v22.x, v24.x and v26.8.2 with a ten-line add-on
whose only distinguishing content is a NAPI_VERSION above
NODE_API_SUPPORTED_VERSION_MAX. `main`, `v22.x-staging` and
`v24.x-staging` all lack the check.

The error path had no test coverage: the message text appears in exactly
one file in the repository, `src/node_api.cc`. A test is added next to
`test_null_init`, which covers the sibling early return in the same
function.

Prepared with assistance from a closed-source coding agent, named in the
pull request description. The design, review and validation are my own:
I verified the fix and the test against a local build, including
removing the four added lines and relinking to confirm the test fails
without them.

Refs: https://github.com/nodejs/node/issues/57233
Signed-off-by: Alexey Karimov <krassx@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66019
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
