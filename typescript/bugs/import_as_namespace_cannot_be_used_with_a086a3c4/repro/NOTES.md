b.js (checkJs) has `@import * as NS from './a'` and `/** @implements {NS.I} */` on a class; a.ts exports interface I.
Clean: only TS2420 (class incorrectly implements I).
Injected: additionally reports a spurious TS1361 "'NS' cannot be used as a value because it was imported using 'import type'" at b.js(5,18).
