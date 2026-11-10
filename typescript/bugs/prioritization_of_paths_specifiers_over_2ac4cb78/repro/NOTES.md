Language-service import code fix for the undefined name `Dialog`; the module lives under `node_modules/@woltlab/wcf/ts/` and a `paths` mapping `*` points at it (with baseUrl).
Clean build offers the paths-based specifier `WoltLabSuite/Core/Component/Dialog`.
Injected build skips the paths-based specifier and offers a different one (the node_modules-based specifier).
