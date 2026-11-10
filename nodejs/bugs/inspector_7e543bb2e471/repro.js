'use strict';
const { isMainThread, Worker } = require('worker_threads');
const { Session } = require('inspector');
const session = new Session();
let done = false;
function onAttachToWorker({ params: { sessionId } }) {
  let id = 1;
  function post(method, params) {
    session.post('NodeWorker.sendMessageToWorker', {
      sessionId, message: JSON.stringify({ id: id++, method, params })
    }, () => {});
  }
  function onMsg({ params: { message } }) {
    if (!message || JSON.parse(message).method !== 'NodeRuntime.waitingForDisconnect') {
      session.once('NodeWorker.receivedMessageFromWorker', onMsg);
      return;
    }
    post('Debugger.setAsyncCallStackDepth', { maxDepth: 1 });
    session.post('NodeWorker.detach', { sessionId }, () => { done = true; });
  }
  onMsg({ params: { message: null } });
  post('Debugger.enable');
  post('NodeRuntime.notifyWhenWaitingForDisconnect', { enabled: true });
  post('Runtime.runIfWaitingForDebugger');
}
session.connect();
session.on('NodeWorker.attachedToWorker', onAttachToWorker);
session.post('NodeWorker.enable', { waitForDebuggerOnStart: true }, () => {
  new Worker('console.log("Worker is done")', { eval: true }).once('exit', () => {
    setTimeout(() => { console.log('done=' + done); }, 0);
  });
});
