window.postToNative =
  window.postToNative ||
  function (data) {
    console.log("%c postToNative %o", "background: #222; color: #bada55", data);
  };
window.eb = window.eb || new EventTarget();
