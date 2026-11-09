// Mocha reporter streaming one JSON line per event to $ETNA_REPORT, so a
// killed run still leaves the results of every test that finished.
const fs = require("fs");
const Mocha = require(require.resolve("mocha", { paths: [process.cwd()] }));
const { EVENT_TEST_BEGIN, EVENT_TEST_PASS, EVENT_TEST_FAIL, EVENT_TEST_PENDING, EVENT_RUN_END } = Mocha.Runner.constants;

class JsonlReporter extends Mocha.reporters.Base {
    constructor(runner, options) {
        super(runner, options);
        const fd = fs.openSync(process.env.ETNA_REPORT, "a");
        const emit = obj => fs.writeSync(fd, JSON.stringify(obj) + "\n");
        runner.on(EVENT_TEST_BEGIN, t => emit({ ev: "begin", title: t.fullTitle() }));
        runner.on(EVENT_TEST_PASS, t => emit({ ev: "pass", title: t.fullTitle() }));
        runner.on(EVENT_TEST_PENDING, t => emit({ ev: "pending", title: t.fullTitle() }));
        runner.on(EVENT_TEST_FAIL, (t, err) => emit({
            ev: "fail",
            title: t.fullTitle(),
            hook: t.type === "hook",
            suite: t.parent ? t.parent.fullTitle() : "",
            err: String((err && (err.stack || err.message)) || err).slice(0, 3000),
        }));
        runner.on(EVENT_RUN_END, () => emit({ ev: "end", stats: this.stats }));
    }
}
module.exports = JsonlReporter;
