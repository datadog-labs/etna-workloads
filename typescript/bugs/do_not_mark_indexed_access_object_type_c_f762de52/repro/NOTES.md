Input declares `T<X> = Pick<X,'x'>` over classes A and B that share `x` but differ elsewhere, then assigns `b = a` (T<A> to T<B>).
Clean tsc reports no errors. The injected build marks the indexed-access object-type comparison as unreliable, so it reports a spurious assignability error.
