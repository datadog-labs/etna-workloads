Input: an ambient module "fs" (via @types/node) re-exported by @types/fs-extra (`export * from "fs"`); the language service asks for completions of `access` with auto-imports, then completion entry details for each `accessSync` entry (passing the entry's `data`).
Clean: both entries (fs, fs-extra) produce details with an "Add import" code action for the matching module.
Injected: the export-map key is ignored, so the fs-extra entry throws "Debug Failure. False expression." instead of returning details and the import code action.
