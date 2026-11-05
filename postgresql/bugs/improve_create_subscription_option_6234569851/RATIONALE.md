# Rationale

Changed: src/backend/commands/subscriptioncmds.c, parse_subscription_options(), in the `slot_name = NONE` combination check.

Traces to the fix.patch hunk that adds the checks "subscription with slot_name = NONE must also set enabled = false" and "... create_slot = false". In current code they are the `else` branches that raise "subscription with %s must also set %s". I removed those branches. The check now errors only when `enabled = true` or `create_slot = true` is given explicitly.

Why this brings the bug back: `CREATE SUBSCRIPTION ... WITH (slot_name = NONE)` is accepted with the default enabled/create_slot = true. That gives an enabled subscription with no slot, which is the situation the fix prevented.

Other hunks (the error message wording and the worker.c slot guard) were not changed.

Oracle case expected to fail: src/test/regress||subscription
