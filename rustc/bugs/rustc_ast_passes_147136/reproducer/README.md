A macro passes `_` as a tt into `pub const $tt`; the clean compiler emits no unused_visibilities warning, while the injected one warns that visibility qualifiers have no effect on `const _`.
