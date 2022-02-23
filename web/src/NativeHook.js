function captureLog(msg) {
  window.webkit.messageHandlers.logHandler.postMessage(msg);
}

function postToNative(data) {
  window.webkit.messageHandlers.native.postMessage(data);
}

const resizeObserver = new ResizeObserver((entries) => {
  for (let entry of entries) {
    postToNative({
      type: "contentHeight",
      value: entry.contentRect.height,
    });
  }
});


window.console.log = captureLog;
window.console.warn = captureLog;
window.console.error = captureLog;
