# Re-introduced bug: vm global has no property query interceptors

Before the fix, the contextified global's named/indexed interceptors had no query callback. Property
existence checks (`Object.hasOwn(this, k)`, getOwnPropertyDescriptor paths) therefore went through the
getter and reported properties inherited from the prototype (e.g. `Object.prototype.onProto`) as own
properties of the context global.

## Change (src/node_contextify.cc, InitializeGlobalTemplates)
- Named handler config: the query slot `PropertyQueryCallback` is now `nullptr`. Corresponds to the fix hunk
  that added `PropertyQueryCallback` to the `NamedPropertyHandlerConfiguration`.
- Indexed handler config: the query slot `IndexedPropertyQueryCallback` is now `nullptr`. Corresponds to the
  fix hunk adding `IndexedPropertyQueryCallback` to the indexed configuration.
The callback definitions/declarations/registrations are left in place (unused, harmless): the current
code has since been reshaped (descriptor slot, flags), so the plain reverse did not apply.

## Result
`parallel/test-vm-global-property-prototype` fails ("not ok", deepEqual actual vs expected mismatch:
prototype-inherited props reported as own). Stable across two runs.
