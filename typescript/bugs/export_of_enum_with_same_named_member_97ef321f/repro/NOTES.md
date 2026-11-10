Input exports an enum `B` (via `export { B }`) whose member has the same name `B`.
Compiled with --module commonjs, the clean build emits `})(B || (exports.B = B = {}));`.
The injected build skips the enum-name case in name resolution, so the export is lost: `})(B || (B = {}));`.
