Assignment-in-condition (while Some(_) = ...) inside a closure: the clean compiler suggests adding `let`; the injected one omits the suggestion because it only looks up fn items as the body owner.
