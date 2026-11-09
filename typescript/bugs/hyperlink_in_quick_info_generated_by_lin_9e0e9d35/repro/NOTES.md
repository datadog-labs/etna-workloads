Input: /b.ts imports `B` from /a.ts and has a JSDoc `{@link B}`; quick info is requested on the documented function via the language service.
Clean: the link's target is the real definition in /a.ts (alias resolved to its target).
Injected: the link target is the import specifier in /b.ts (alias not resolved).
