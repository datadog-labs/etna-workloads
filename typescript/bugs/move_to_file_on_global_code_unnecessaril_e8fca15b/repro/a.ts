// this file extends the string prototype
interface String {
    reverse(): string;
}
String.prototype.reverse = function(): string {
    return this.split("").reverse().join("");
};
