import app from "./model";

app("#app", {
  userDefaults: !window.webkit,
  state: {
    content: "",
    allowDebug: true,
  },
  data() {
    return {
      currentTheme: "",
    };
  },

  methods: {
    copyToClipboard: function () {
      var textToCopy = this.content;
      if (navigator.clipboard && window.isSecureContext) {
        return navigator.clipboard.writeText(textToCopy);
      } else {
        // text area method
        let textArea = document.createElement("textarea");
        textArea.value = textToCopy;
        // make the textarea out of viewport
        textArea.style.position = "fixed";
        textArea.style.left = "-999999px";
        textArea.style.top = "-999999px";
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        return new Promise((res, rej) => {
          // here the magic happens
          document.execCommand("copy") ? res() : rej();
          textArea.remove();
        });
      }
    },
    handleInput(e) {
      var innerText = e.currentTarget.innerText;
      this.content = innerText;
    },
    adjustHeight() {
      if (this.isDebug) {
        let target = document.querySelector("textarea");
        target.style.height = "5px";
        nextTick(() => {
          var height = target.scrollHeight;
          target.style.height = height + "px";
        });
      }
    },
  },
  watch: {
    currentTheme(value) {
      this.userDefaults.set("theme", value);
      $(`link[title='${value}']`)
        .removeAttr("disabled")
        .attr("rel", "stylesheet");
      for (var title of ["auto", "dark", "light"]) {
        if (value != title) {
          $(`link[title='${title}']`).attr("disabled", "").removeAttr("rel");
        }
      }
      if (!window.webkit) {
        switch (value) {
          case "dark":
            $("body").css("background-color", "black");
            break;
          case "light":
            $("body").css("background-color", "white");
            break;
          default:
            $("body").css("background-color", "");
            break;
        }
      }
    },
    content() {
      this.adjustHeight();
    },
    isDebug: {
      handler() {
        nextTick().then(this.adjustHeight);
      },
      immediate: false,
    },
  },
  computed: {
    htmlContent() {
      return marked(this.content);
    },
    isDebug() {
      return this.allowDebug && !window.webkit;
    },
    appStyle() {
      return {
        margin: this.isDebug ? "24px" : "0px",
      };
    },
  },
  async mounted() {
    setTimeout(() => {
      this.adjustHeight();
    }, 300);
    if (this.isDebug) {
      this.currentTheme =
        (await this.userDefaults.get("theme")) ||
        $("link[title]:not([disabled])").attr("title") ||
        "auto";
    }
    $("#inputArea").on("keydown", async function (e) {
      let [start, end] = [this.selectionStart, this.selectionEnd];
      let p1 = this.value.substring(0, start);
      let p2 = this.value.substring(start, end);
      let p3 = this.value.substring(end);
      switch (e.keyCode) {
        case 67:
          if (e.ctrlKey) {
            e.preventDefault();
            e.stopPropagation();
            this.value = p1 + "\n```\n" + p2 + "\n```\n" + p3;
            this.selectionStart = this.selectionEnd = end + 5;
            m.vm.content = this.value;
          }
          break;
        case 72:
          if (e.ctrlKey) {
            e.preventDefault();
            e.stopPropagation();

            this.value = p1 + "\n## " + p2 + (start == end ? "" : "\n") + p3;
            this.selectionStart = this.selectionEnd = start + 4 + p2.length;
            m.vm.content = this.value;
          }
          break;
        case 66:
          if (e.ctrlKey) {
            e.preventDefault();
            e.stopPropagation();
            this.value = p1 + "**" + p2 + "**" + p3;
            this.selectionStart = this.selectionEnd = start + 2 + p2.length;
            m.vm.content = this.value;
          }
          break;
        case 73:
          if (e.ctrlKey) {
            e.preventDefault();
            e.stopPropagation();
            this.value = p1 + "`" + p2 + "`" + p3;
            this.selectionStart = this.selectionEnd = start + 1 + p2.length;
            m.vm.content = this.value;
          }
        default:
          // console.log(e.keyCode);
          break;
      }
    });
    if (!window.webkit) {
      fetch("./example.md")
        .then((res) => res.text())
        .then(function (text) {
          m.vm.content = text;
          postToNative({
            type: "example",
            content: text,
          });
        });
    }
    postToNative({
      type: "mounted",
    });
  },
});

// function onReceiveNative(html) {
//   try {
//     postToNative({
//       type: "toMarkdown",
//       value: toMarkdown(html),
//     });
//   } catch (e) {
//     console.log(e);
//   }
// }

// eb.addEventListener("toMarkdown", function (e) {
//   onReceiveNative(e.detail);
// });

let theme = new Proxy(
  {},
  {
    get: (target, key) => {
      if (key === "current") {
        return target.theme || $("link[title]:not([disabled])").attr("title");
      }
      return target[key];
    },
    set: (target, key, value) => {
      if (key === "current") {
        vm.currentTheme = value;
        target.theme = value;
        $(`link[title='${value}']`)
          .removeAttr("disabled")
          .attr("rel", "stylesheet");
        for (var title of ["auto", "dark", "light"]) {
          if (value != title) {
            $(`link[title='${title}']`).attr("disabled", "").removeAttr("rel");
          }
        }
        if (!window.webkit) {
          switch (value) {
            case "dark":
              $("body").css("background-color", "black");
              break;
            case "light":
              $("body").css("background-color", "white");
              break;
            default:
              $("body").css("background-color", "");
              break;
          }
        }
      }
      target[key] = value;
      return true;
    },
  }
);
document.addEventListener("paste", function (e) {
  if (e.target.getAttribute("contenteditable")) {
    return;
  }
  let html = e.clipboardData.getData("text/html");
  let text = html ? toMarkdown(html) : e.clipboardData.getData("text/plain");
  m.vm.content = text;
  e.preventDefault();
  e.stopPropagation();
});
