Compiles an empty main with RUSTC_LOG=trace. The injected compiler traces the whole LocalDefId in def_path_hash too early, panicking (exit 101, ICE); the clean one compiles fine (exit 0).
