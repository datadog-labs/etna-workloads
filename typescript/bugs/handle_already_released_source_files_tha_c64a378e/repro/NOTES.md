Language service with a shared document registry: a.ts is imported by b.ts. In one update the host changes a.ts's script kind (TS -> JS) and b.ts gains a new import, so structure reuse fails and a.ts is looked up twice in the same sync.
Clean: prints 0, 0, 1 (a.ts reloaded with scriptKind JS).
Injected: the second lookup releases a.ts again, and getSemanticDiagnostics throws "Debug Failure ... Script kind should match provided ScriptKind".
