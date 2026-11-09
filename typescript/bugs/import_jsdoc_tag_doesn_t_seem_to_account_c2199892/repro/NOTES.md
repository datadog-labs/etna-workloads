a.js (CommonJS-mode under node16) uses a JSDoc `@import { Import } from 'foo' with { 'resolution-mode': 'import' }`; foo's exports differ by condition.
Clean: the resolution-mode override is honored, so the ESM types resolve and `return 1` reports TS2322 against "module".
Injected: the override is ignored for @import tags, giving TS2305 "no exported member 'Import'" instead.
