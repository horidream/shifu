import { reactive, watch, toRaw } from "@vue/runtime-core";

if (typeof globalThis.postToNative == "undefined") {
  // functions that called from js side and will be handled by swift
  const captureLog = function (...msg) {
    window.webkit?.messageHandlers?.logHandler?.postMessage(msg.join(" "));
  }

  const postToNative = window.webkit
    ? function (data) {
        window.webkit?.messageHandlers?.native?.postMessage(data);
      }
    : function (data) {
        console.log(
          "%c postToNative %o",
          "background: #222; color: #bada55",
          data
        );
      };

  // functions that could be called by bothsides
  const emit = function (type, data) {
    eb.dispatchEvent(new CustomEvent(type, { detail: data }));
  }

  const watchAttribute = function (target, attribute, callback, args) {
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

  const defineGlobal = function (key, value) {
    if (!globalThis.hasOwnProperty(key)) {
      Object.defineProperty(globalThis, key, { value, writable: false });
    }
  }
  let bridge = reactive({ a: 1, b: 2 });
  watch(
    () => bridge,
    function (newValue) {
      window.webkit?.messageHandlers?.webViewBridge?.postMessage(
        toRaw(newValue)
      );
    },
    {deep: true}
  );

  defineGlobal("postToNative", postToNative);
  defineGlobal("js", {
    watchAttribute,
    emit
  });
  defineGlobal("bridge", bridge);
  // defineGlobal("eb", new EventTarget());
  // define global
  if (window.webkit) {
    window.console.log = captureLog;
    window.console.warn = captureLog;
    window.console.error = captureLog;
    window.onerror = captureLog;
  }
}
