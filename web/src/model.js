import {
	toMarkdown,
	loadJQuery,
	declareModel,
	genModel,
	configureDepsPath,
	loadSkinTemplate,
	sfc,
	loadGSAP,
} from "grogu";

// Shifu's webpack bridge requires direct global access to these utilities
if (typeof window !== 'undefined') {
	// Import and expose required globals for webkit bridge
	window.loadSkinTemplate = window.sfc = loadSkinTemplate;
	window.loadGSAP = loadGSAP;
	window.loadJQuery = loadJQuery;
	window.toMarkdown = toMarkdown;
}
import * as marked from "marked";
import { markedHighlight } from "marked-highlight";
import hljs from "highlight.js";
import katex from "katex";
import objectivec from "highlight.js/lib/languages/objectivec";

hljs.registerLanguage("objective-c", objectivec);
let renderer = new marked.Renderer();
marked.setOptions({
  renderer,
  pedantic: false,
  gfm: true,
  tables: true,
  breaks: false,
  sanitize: false,
  smartLists: true,
  smartypants: false,
  mangle: false,
  headerIds: false,
  xhtml: false,
});
marked.use(
	markedHighlight({
		// langPrefix: "hljs language-",
		highlight: function (code, language) {
		  if (!hljs.getLanguage(language)) {
		    return hljs.highlightAuto(code).value;
		  }

		  return hljs.highlight(code, { language }).value;
		}
	})
);

function mathsExpression(expr) {
  expr = expr.text ?? expr;
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
  return null;
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

export default declareModel("com.horidream.lib.shifu", async function (el, options) {
  let store = {
    state: {},
  };
  await loadJQuery();
  let model = await genModel(store, options, el);
  return model;
});
