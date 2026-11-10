Input: a distributive conditional `IsNumber<T>` instantiated with `{x:true} & {x:false}` (reduces to never), then `true` is assigned to it.
Clean: the type reduces to `never`, so tsc reports "Type 'true' is not assignable to type 'never'".
Injected: the never-intersection isn't reduced before distribution, so the type becomes `true` and no error is reported.
