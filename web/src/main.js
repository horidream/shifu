import cm from "grogu"
const marked = require("marked");
import hljs from "highlight.js";
import katex from "katex";

hljs.registerLanguage("objective-c", require("highlight.js/lib/languages/objectivec"));

let renderer = new marked.Renderer()
marked.setOptions({
  renderer,
  highlight: function (code, language) {
    if (!hljs.getLanguage(language)) {
      return hljs.highlightAuto(code).value;
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

function mathsExpression(expr) {
  // if (expr.match(/^\$\$[\s\S]*\$\$$/)) {
  //   expr = expr.substr(2, expr.length - 4);
  //   return katex.renderToString(expr, { displayMode: true });
  // } else if (expr.match(/^\$[\s\S]*\$$/)) {
  //   expr = htmldecode(expr); // temp solution
  //   expr = expr.substr(1, expr.length - 2);
  //   return katex.renderToString(expr, { displayMode: false });
  // }

  if (expr.match(/^\$\$[\s\S]*\$\$$/)) {
    expr = expr.substr(2, expr.length - 4);
    return katex.renderToString(expr, {
      displayMode: true,
      throwOnError: false,
    });
  }else if(expr.match(/^\$[\s\S]*\$$/)){
    expr = expr.substr(1, expr.length - 2);
    return katex.renderToString(expr, { displayMode: false, throwOnError: false });
  }
}

const unchanged = new marked.Renderer();

renderer.code = function (code, lang, escaped) {
  if (!lang) {
    const math = mathsExpression(code);
    if (math) {
      return math;
    }
  }
  return unchanged.code(code, lang, escaped);
};

renderer.codespan = function (text) {
  const math = mathsExpression(text);
  if (math) {
    return math;
  }
  return unchanged.codespan(text);
};


window.marked = marked.marked;
window.hljs = hljs;

window.postToNative = window.postToNative || function (data) { console.log(data); };
window.eb = window.eb || new EventTarget();

cm.declareModel("com.horidream.lib.shifu", async function(el, options){
  let store = {
    state: {
    }
  }
  let model = await cm.genModel(store, options, el);
  postToNative({
    type: "mounted",
  });
  return model;
});

