resizeObserver.observe(document.querySelector("html"));
if (!window.__manage_mounted_event__) {
  postToNative({
    type: "ready",
  });
}