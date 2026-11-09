type Animal = { breath: true };
type Rock = { breath: false };
type Something = Animal | Rock;
function isAnimal(something: Something): something is Animal {
  return something.breath;
}
export function negative(t: Something) {
  return !isAnimal(t);
}
