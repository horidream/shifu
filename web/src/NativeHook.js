function captureLog(msg) {
  window.webkit.messageHandlers.logHandler.postMessage(msg);
}

function postToNative(data) {
  window.webkit.messageHandlers.native.postMessage(data);
}
window.console.log = captureLog;
window.console.warn = captureLog;
window.console.error = captureLog;
