Input a.js has imports preceded by JSDoc `/** @private */` / `/** @public */` comments, checked with `tsc --allowJs --checkJs`.
Clean: no TS1191 error for these imports. Injected: reports "An import declaration cannot have modifiers" (TS1191) because JSDoc tags count as effective modifiers.
