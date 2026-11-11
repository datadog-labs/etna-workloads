Compiles an async fn returning a bare dyn Trait; E0746's primary span should point at the return type, but with the bug it points at the whole function body.
