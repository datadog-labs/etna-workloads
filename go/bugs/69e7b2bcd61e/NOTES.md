Type switch on an invalid expression (`e` from a failing `range x.m()`) used to return early in
types2, so the case bodies were never type-checked. The buggy compiler additionally reports
`"fmt" imported and not used`; the clean one reports only `x.m undefined`.
