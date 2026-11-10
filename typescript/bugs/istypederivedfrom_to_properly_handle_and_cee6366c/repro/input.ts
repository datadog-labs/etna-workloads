interface InstanceOne { one(): void }
interface InstanceTwo { two(): void }
declare const instance: InstanceOne | InstanceTwo;
declare const ClassOne: { new(): InstanceOne } & { foo: true };
if (instance instanceof ClassOne) {
    instance.one();
}
