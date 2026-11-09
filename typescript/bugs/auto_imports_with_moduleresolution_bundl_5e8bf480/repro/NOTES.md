Language-service code fix for undefined `dep` in a project with `moduleResolution: bundler` and `customConditions: ["custom"]`; `dep`'s package.json exports map `.` only under the `custom` condition.
Clean offers `Add import from "dep"`; injected ignores customConditions when resolving exports and offers `Add import from "dep/dist"`.
