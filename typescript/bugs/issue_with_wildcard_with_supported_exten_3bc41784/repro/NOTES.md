Opens a configured project (tsconfig includes only *.ts) through ts.server.ProjectService. A plugin adds .vue files via getExternalFiles and returns ScriptKind.TS for them from getScriptKind.
The script then creates c.vue and fires the wildcard directory watcher for it.
Clean: the .vue file counts as a supported script kind, so the project reloads and c.vue is added to it.
Injected: c.vue is ignored as "non supported extension", so no reload is scheduled and c.vue is never added.
