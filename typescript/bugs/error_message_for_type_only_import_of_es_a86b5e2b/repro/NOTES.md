common.cts does a type-only import of an ES module (module.mts) under module=node18, without a resolution-mode attribute.
Clean: error TS1541 "Type-only import of an ECMAScript module from a CommonJS module must have a 'resolution-mode' attribute."
Injected: generic TS1479 "The current file is a CommonJS module whose imports will produce 'require' calls..." instead.
