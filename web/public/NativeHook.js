// functions that called from js side and will be handled by swift
function captureLog(...msg) {
  window.webkit?.messageHandlers?.logHandler?.postMessage(msg.join(" "));
}

function postToNative(data) {
  window.webkit?.messageHandlers?.native?.postMessage(data);
}

// functions that could be called by bothsides
function emit(type, data) {
  eb.dispatchEvent(new CustomEvent(type, { detail: data }));
}

// define global
window.eb = window.eb || new EventTarget();
if (window.webkit) {
  window.console.log = captureLog;
  window.console.warn = captureLog;
  window.console.error = captureLog;
  window.onerror = captureLog;
}
