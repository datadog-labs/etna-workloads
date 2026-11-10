declare const perf: { mark(): void; measure(): void } | undefined;
if (
  (
    perf &&
    perf.mark &&
    perf.measure
  ) ?? !!true
) {
  perf!.mark();
}
