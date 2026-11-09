type Left = 'left';
type Right = 'right' & { right: 'right' };
type Either = Left | Right;

function assertNever(v: never): never {
    throw new Error('never');
}

export function fx20(value: Either) {
    if (value === 'left') {
    }
    else if (value === 'right') {
    }
    else {
        assertNever(value);
    }
}
