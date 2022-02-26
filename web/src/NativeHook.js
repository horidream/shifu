function captureLog(...msg) {
  window.webkit.messageHandlers.logHandler.postMessage(msg.join(" "));
}

function postToNative(data) {
  window.webkit.messageHandlers.native.postMessage(data);
}

const eb = new EventTarget();
function onNative(type, data) {
  eb.dispatchEvent(new CustomEvent(type, { detail: data }));
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
