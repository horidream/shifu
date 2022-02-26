import { toMarkdown } from "grogu/utils";

window.postToNative =
  window.postToNative ||
  function (data) {
    console.log(data);
  };
window.eb = window.eb || new EventTarget();

function readHTML() {
  return navigator.clipboard.read().then((data) => {
    let items = data.filter((item) => item.types.includes("text/html"));
    if (items.length > 0) {
      return new Promise((resolve, reject) => {
        items[0].getType("text/html").then((blob) => {
          var reader = new FileReader();
          reader.addEventListener("loadend", function () {
            resolve(reader.result);
          });
          reader.readAsText(blob);
        });
      });
    } else {
      return navigator.clipboard.readText();
    }
  });
}

function convertToMarkdown() {
  return readHTML()
    .catch((err) => {
      return new Promise((resolve) => {
        window.addEventListener("focus", function () {
          resolve(readHTML());
        });
      });
    })
    .then((html) => {
      return toMarkdown(html);
    });
}


window.toMarkdown = toMarkdown;
