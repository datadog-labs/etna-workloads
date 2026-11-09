class C {
    caller = () => {
        callee();
    };
}
function callee() {}
