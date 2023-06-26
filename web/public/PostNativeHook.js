const __resizeObserver = new ResizeObserver((entries) => {
  for (let entry of entries) {
    postToNative({
      type: "contentHeight",
      value: entry.contentRect.height,
    });
  }
});
__resizeObserver.observe(document.querySelector("html"));

if (!window.__manage_mounted_event__) {
  postToNative({
    type: "ready",
  });
}else{
  postToNative({
		type: "__ready__",
  });
}
