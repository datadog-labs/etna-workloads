Creates a watch program (in-memory sys) for a project under /workspaces/proj with an unresolved `import "foo"`, and logs the directories passed to watchDirectory/watchFile.
Clean: failed-lookup watches are placed at /workspaces/proj-level locations (the "/workspaces" special case keeps the root at depth 2).
Injected: /workspaces is treated like a home dir (root depth 3), so the watched directories differ.
