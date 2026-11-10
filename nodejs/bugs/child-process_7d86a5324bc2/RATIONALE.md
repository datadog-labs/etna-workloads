# Re-introduced bug: 'http_parser' monkey patching broken by eager loading in child_process

## Bug
`lib/internal/child_process.js` loaded `_http_common` (and thereby the `http_parser` binding's
`HTTPParser`) at module load time. Since `child_process` is required very early, any
`internalBinding('http_parser').HTTPParser` monkey patch applied by user code (e.g. http-parser-js)
came too late: `_http_common` had already captured the original native parser.

## Change (lib/internal/child_process.js, 3 edits = the 3 hunks of the fix, reversed)
1. Fix hunk 1 removed the top-level `const { HTTPParser } = internalBinding('http_parser')` and
   `const { freeParser } = require('_http_common')`. I re-added both after the `spawn_sync` binding line.
2. Fix hunk 2 added lazy `let freeParser; let HTTPParser;` declarations (today's code has
   the same, with a comment). I removed them, since they would clash with the eager constants.
3. Fix hunk 3 added the lazy-require block in the `net.Socket` handle conversion. Today's code gets
   `HTTPParser` from `require('_http_common')`. I removed the block, so the eager constants are used.

Together these make `_http_common` load eagerly during bootstrap, before any patching is possible.

## Failing test
`parallel/test-http-parser-lazy-loaded` fails (`not ok`, stable across runs). The patched
`HTTPParser` is ignored, so `parsers.alloc()` constructs the native parser with the dummy `REQUEST` symbol:

    Assertion failed: args[0]->IsInt32()   (src/node_http_parser.cc:694, Parser::Initialize)
    severity: crashed, exitcode: -6
