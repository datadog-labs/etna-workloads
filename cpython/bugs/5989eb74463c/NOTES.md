Watches `o.__dict__` of a plain instance with a C dict watcher (`_testcapi`), then sets, modifies and deletes an attribute.
Clean: `['new:foo:bar', 'mod:foo:baz', 'del:foo']`. Buggy: the inline-values store path no longer notifies watchers, so the event list differs (missing events).
