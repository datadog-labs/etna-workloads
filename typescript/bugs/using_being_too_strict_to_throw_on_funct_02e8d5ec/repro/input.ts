const fn: any = function () {};
fn[Symbol.dispose] = () => console.log("disposed function");
{
    using x = fn;
}
console.log("done");
