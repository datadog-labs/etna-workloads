# Rationale

File: src/backend/commands/subscriptioncmds.c, function AlterSubscription(), case ALTER_SUBSCRIPTION_ADD/DROP_PUBLICATION.

Hunk 1 (fix_impl.patch hunk 1): supported_opts is again `SUBOPT_REFRESH` plus `SUBOPT_COPY_DATA` only for ADD. This restores the old behaviour in which DROP PUBLICATION rejects copy_data.

Hunk 2 (fix_impl.patch hunk 2): before refreshing, `sub->publications = stmt->publication` (only the added/dropped list) replaces the merged `publist`. The refresh then sees only the publications named in the command, not the subscription's full list. Tables from the other publications are treated as no longer subscribed and removed. After a DROP, the refresh sees the dropped publications as the subscription's list.

The psql tab-complete hunk is not part of the backend bug and is not reverted.

Failing oracle cases:
- src/test/subscription|t/024_add_drop_pub.pl|check initial data is copied to subscriber#2
- src/test/subscription|t/024_add_drop_pub.pl|check initial data is copied to subscriber#3
