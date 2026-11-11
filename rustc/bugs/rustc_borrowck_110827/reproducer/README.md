Type alias with a generic param and dyn + 'static: the borrowck suggestion should add the lifetime as 'type Lazy<'a, T>'; the injected compiler suggests the malformed 'type Lazy<T><'a>'.
