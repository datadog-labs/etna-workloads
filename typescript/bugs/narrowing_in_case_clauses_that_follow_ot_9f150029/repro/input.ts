function test(arg: string | undefined) {
  if (!arg) throw new Error();
  switch (true) {
    case arg.toUpperCase() === "A":
      return "A";
    case arg.toUpperCase() === "B":
    case arg.toUpperCase() === "C":
      return "B or C";
  }
  return "none";
}
