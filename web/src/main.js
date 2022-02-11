import cm from "grogu"
const marked = require("marked");
import hljs from "highlight.js";



marked.setOptions({
  renderer: new marked.Renderer(),
  highlight: function (code, language) {
    if (!hljs.getLanguage(language)) {
      language = "plaintext";
    }
    return hljs.highlight(code, { language }).value;
  },
  pedantic: false,
  gfm: true,
  tables: true,
  breaks: false,
  sanitize: false,
  smartLists: true,
  smartypants: false,
  xhtml: false,
});

window.marked = marked.marked;
window.hljs = hljs;



cm.declareModel("com.horidream.lib.shifu", async function(el, options){
  let store = {
    state: {
    }
  }
  let model = await cm.genModel(store, options, el);
  options.onStart && options.onStart.call(model);
  return model;
});

