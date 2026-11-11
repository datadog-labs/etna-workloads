Compiles an async move closure capturing a &mut i32 and consumes it via AsyncFnOnce; the injected compiler ICEs in by_move_body (single-deref assertion) while the clean one compiles and prints x = 1.
