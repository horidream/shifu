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


var meta = document.createElement("meta");
meta.name = "viewport";
meta.content =
	"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no";
document.getElementsByTagName("head")[0].appendChild(meta);