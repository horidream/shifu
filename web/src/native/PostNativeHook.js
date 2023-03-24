const resizeObserver = new ResizeObserver((entries) => {
  for (let entry of entries) {
    postToNative({
      type: "contentHeight",
      value: entry.contentRect.height,
    });
  }
});
resizeObserver.observe(document.querySelector("html"));

if (!window.__manage_mounted_event__) {
  postToNative({
    type: "ready",
  });
}
