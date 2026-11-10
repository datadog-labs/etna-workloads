'use strict';
const v8 = require('v8');
v8.setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const { channel } = require('diagnostics_channel');

(function() { channel('test-gc'); })();   // dropped, becomes garbage
setTimeout(() => {
  gc();                                    // old channel dead; finalizer queued
  const held = channel('test-gc');         // replaces the dead WeakRef
  setTimeout(() => {                       // finalizer has run by now
    console.log('same instance:', held === channel('test-gc'));
  }, 50);
}, 10);
