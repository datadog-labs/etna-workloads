# Re-introduced bug: 'npm ' treated as npm command even for recoverable errors (86bdca9772f6)

**Bug.** In the REPL, input starting with `npm ` whose evaluation fails is assumed to be an attempt to run npm,
and the "npm should be run outside of the Node.js REPL" message is printed. This also happens when the error
is a `Recoverable` (incomplete input, e.g. `npm +\n1`, where `npm` is a user variable), so multi-line
continuation is cut short and the message is shown wrongly.

**Hunk (lib/repl.js, finish() in the eval callback).** Corresponds to the single hunk of the fix, which added
`&& !(e instanceof Recoverable)` to the `npm ` check. The release has moved that code (now ~line 836, and it
uses `FunctionPrototypeCall`), so I removed the `!(e instanceof Recoverable)` condition from the current
condition. That restores the pre-fix behaviour.

**Tests.** parallel/test-repl contains the fix's cases (`npm ( \n)`, `npm +\n1; undefined`, etc., expecting
`... undefined`). In this sandbox the test could not run to completion: it aborts with
`Error: listen EPERM ... node-test.64.sock` (sandbox forbids unix-socket listen), so the TAP "not ok" here is
an environment failure, not evidence of the bug. I verified the bug manually instead:
`printf 'let npm = () => {};\nnpm +\n1; undefined\n' | out/Release/node -i` prints
"npm should be run outside of the Node.js REPL..." where the fixed build prints a continuation (`... undefined`).
Outside the sandbox, test-repl should fail with that mismatch on the `npm +\n1; undefined` cases.
