Input: a function whose parameter `Foo` is shadowed by a local `type Foo = typeof Foo`. A language service requests semantic classifications and then semantic diagnostics.
Clean: no diagnostics. Injected: spurious errors 2502 ("'Foo' is referenced directly or indirectly in its own type annotation") and 2456 ("Type alias 'Foo' circularly references itself").
