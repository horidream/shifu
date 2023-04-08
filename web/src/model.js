import grogu from "grogu";
import * as marked from "marked";
import hljs from "highlight.js";
import katex from "katex";
import { toMarkdown } from "grogu/utils";
import objectivec from "highlight.js/lib/languages/objectivec";

hljs.registerLanguage("objective-c", objectivec);
let renderer = new marked.Renderer();
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
  if (expr.match(/^\$\$[\s\S]*\$\$$/)) {
    expr = expr.substr(2, expr.length - 4);
    return katex.renderToString(expr, {
      displayMode: true,
      throwOnError: false,
    });
  } else if (expr.match(/^\$[\s\S]*\$$/)) {
    expr = expr.substr(1, expr.length - 2);
    return katex.renderToString(expr, {
      displayMode: false,
      throwOnError: false,
    });
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

renderer.checkbox = function (value) {
  return value
  ? `<input checked="" type="checkbox">`
  : `<input type="checkbox">`;
};

window.marked = marked.marked;
window.hljs = hljs;
window.toMarkdown = toMarkdown;

export default grogu.declareModel("com.horidream.lib.shifu", async function (el, options) {
  let store = {
    state: {},
  };
  await grogu.injectVendorLibs({jquery: true})
  let model = await grogu.genModel(store, options, el);
  return model;
});
