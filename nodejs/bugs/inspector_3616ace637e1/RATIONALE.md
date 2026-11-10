# Re-introduced bug (upstream 3616ace637e1)

**Bug:** Before the fix, the inspector Network agent did not carry real request/response header data (and response status/type info) to DevTools, which caused frontend errors. After the fix, headers are passed through. The release has since been rewritten (`createHeadersFromObject`, `createRequestFromObject`, `createResponseFromObject` in `src/inspector/network_agent.cc`), so the fix's hunks do not reverse-apply.

**Change (one hunk, `src/inspector/network_agent.cc`, `NetworkAgent::createHeadersFromObject`):** if the headers object has any properties, throw a TypeError ("Headers are not supported in event") and return nothing. It corresponds to the fix's hunks that made `requestWillBeSent`/`responseReceived` read and forward `headers` (and `response`); removing that support restores the pre-fix behaviour where non-empty header data is not delivered to the frontend. The empty-headers case still works.

**Failing test:** `parallel/test-inspector-emit-protocol-event` -> `not ok`, `TypeError: Headers are not supported in event`. It is thrown when `Network.responseReceived` is emitted with `headers: { host: 'nodejs.org' }`. Failure is stable over 2 runs.

**Fidelity note:** a quieter variant that silently dropped the headers only produced an assertion warning inside the event handler, which the test does not treat as a failure. That is why this variant throws.
