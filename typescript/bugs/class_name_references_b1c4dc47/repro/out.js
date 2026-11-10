"use strict";
class C {
    m() { return () => C; }
}
C.x = 1;
C.y = C.x + 1;
(() => {
    console.log(C.y);
})();
