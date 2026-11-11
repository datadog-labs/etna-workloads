Cloning a `&HashSet<Day>` where `Day: !Clone` gives a type mismatch; the fixed compiler also suggests `#[derive(Clone)]` on `Day`, the injected one omits that suggestion.
