let iNext: string | number = "";
for (let i = 0; i < 10; i = iNext) {
  if (i == 5) {
    iNext = "bad";
    continue;
  }
  iNext = i + 1;
}
