type T = {
    thing?: { name: 'A', message: string } | { name: 'B', id: string }
};
declare const t: T;
if (t.thing!.name !== "B") {
    console.log(t.thing!.message);
} else {
    console.log(t.thing!.id);
}
