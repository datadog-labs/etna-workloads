import { infer } from "./infer";
infer({
    m: {
        initData() {
            this.x = 1;
            this.x;
        },
    }
});
