type R = { ok: false; data: undefined } | { ok: true; data: number };
function f({ data, ok }: R) {
    const isOk = ok;
    if (isOk) {
        data.toExponential();
    }
}
