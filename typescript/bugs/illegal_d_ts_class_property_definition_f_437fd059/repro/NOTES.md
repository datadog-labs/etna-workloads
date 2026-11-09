a.js has a class whose method assigns `this.constructor = a`. Declaration emit with --allowJs runs on it.
Clean: .d.ts omits the `constructor` property. Injected: emits `constructor: any;` inside the class,
which is invalid d.ts (parse error TS1005).
