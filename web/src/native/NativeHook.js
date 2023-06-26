import { reactive, watch, toRaw } from "@vue/runtime-core";
import { observe } from "./MutationObserve";

if (typeof globalThis.postToNative == "undefined") {
  // functions that called from js side and will be handled by swift
  (async function () {
    const captureLog = function (...msg) {
      window.webkit?.messageHandlers?.logHandler?.postMessage(msg.join(" "));
    };

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
    };

    const defineGlobal = function (key, value) {
      if (!globalThis.hasOwnProperty(key)) {
        Object.defineProperty(globalThis, key, { value, writable: false });
      }
    };
    let bridge = reactive({ });
    watch(
      () => bridge,
      function (newValue) {
        window.webkit?.messageHandlers?.webViewBridge?.postMessage(
          toRaw(newValue)
        );
      },
      { deep: true }
    );
    defineGlobal("bridge", bridge);

    defineGlobal("postToNative", postToNative);
    defineGlobal("observe", observe);
    // defineGlobal("eb", new EventTarget());
    // define global
    if (window.webkit) {
      window.console.log = captureLog;
      window.console.warn = captureLog;
      window.console.error = captureLog;
      window.onerror = captureLog;
    }
  })();
}
