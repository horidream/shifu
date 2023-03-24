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

function watchAttribute(target, attribute, callback, args) {
  var { immediate } = args || { immediate: false };
  if (typeof target == "string") {
    target = document.querySelector(target);
  }
  var [attributeName, valueKey] = attribute.split(".");
  var previouValue = null;
  var observer = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      if (mutation.attributeName !== attributeName) return;
      var currentValue;
      if (valueKey == undefined && attributeName != "style") {
        currentValue = mutation.target.getAttribute(attributeName);
      } else {
        currentValue = mutation.target[attributeName][valueKey];
      }
      if (currentValue != previouValue) {
        callback(currentValue);
        previouValue = currentValue;
      }
    });
  });
  var config = { attributes: true };
  observer.observe(target, config);
  if (immediate) {
    if (valueKey == undefined && attributeName != "style") {
      previouValue = target.getAttribute(attributeName);
    } else {
      previouValue = target[attributeName][valueKey];
    }
    callback(previouValue);
  }
}

// define global
window.eb = window.eb || new EventTarget();
if (window.webkit) {
  window.console.log = captureLog;
  window.console.warn = captureLog;
  window.console.error = captureLog;
  window.onerror = captureLog;
  Object.assign(window, {postToNative, watchAttribute})
}
