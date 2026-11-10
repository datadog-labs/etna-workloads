'use strict';
// Reproducer for: ffi: validate DynamicLibrary getter receivers
// (upstream fix bdcb6def4e6e4abd67842cc88405bb917073040c)
//
// The native accessor for DynamicLibrary.prototype.functions (and friends)
// must reject receivers that are not actual DynamicLibrary instances before
// invoking the native callback. Without the V8 Signature binding, the
// native callback unwraps an arbitrary receiver object as if it were a
// DynamicLibrary, which crashes the process instead of throwing a
// catchable TypeError.

process.noDeprecation = true;
process.emitWarning = () => {};

const { DynamicLibrary } = require('node:ffi');

const descriptor = Object.getOwnPropertyDescriptor(
  DynamicLibrary.prototype,
  'functions',
);

try {
  descriptor.get.call({});
  console.log('no throw');
} catch (e) {
  console.log(e.name);
}
