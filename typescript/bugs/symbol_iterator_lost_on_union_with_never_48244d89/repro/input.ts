declare var x: number[] | ({ t: "a" } & { t: "b" });
let [el2] = x;
for (const elem of x) {
  elem.toFixed();
}
