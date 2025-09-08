function ae(c) {
  return c && c.__esModule && Object.prototype.hasOwnProperty.call(c, "default") ? c.default : c;
}
var g = { exports: {} }, le = g.exports, P;
function se() {
  return P || (P = 1, function(c, ue) {
    (function(k, h) {
      c.exports = h();
    })(le, function() {
      function k(e) {
        for (var r = 1; r < arguments.length; r++) {
          var t = arguments[r];
          for (var n in t)
            t.hasOwnProperty(n) && (e[n] = t[n]);
        }
        return e;
      }
      function h(e, r) {
        return Array(r + 1).join(e);
      }
      function L(e) {
        return e.replace(/^\n*/, "");
      }
      function M(e) {
        for (var r = e.length; r > 0 && e[r - 1] === `
`; ) r--;
        return e.substring(0, r);
      }
      var I = [
        "ADDRESS",
        "ARTICLE",
        "ASIDE",
        "AUDIO",
        "BLOCKQUOTE",
        "BODY",
        "CANVAS",
        "CENTER",
        "DD",
        "DIR",
        "DIV",
        "DL",
        "DT",
        "FIELDSET",
        "FIGCAPTION",
        "FIGURE",
        "FOOTER",
        "FORM",
        "FRAMESET",
        "H1",
        "H2",
        "H3",
        "H4",
        "H5",
        "H6",
        "HEADER",
        "HGROUP",
        "HR",
        "HTML",
        "ISINDEX",
        "LI",
        "MAIN",
        "MENU",
        "NAV",
        "NOFRAMES",
        "NOSCRIPT",
        "OL",
        "OUTPUT",
        "P",
        "PRE",
        "SECTION",
        "TABLE",
        "TBODY",
        "TD",
        "TFOOT",
        "TH",
        "THEAD",
        "TR",
        "UL"
      ];
      function v(e) {
        return A(e, I);
      }
      var b = [
        "AREA",
        "BASE",
        "BR",
        "COL",
        "COMMAND",
        "EMBED",
        "HR",
        "IMG",
        "INPUT",
        "KEYGEN",
        "LINK",
        "META",
        "PARAM",
        "SOURCE",
        "TRACK",
        "WBR"
      ];
      function w(e) {
        return A(e, b);
      }
      function _(e) {
        return R(e, b);
      }
      var C = [
        "A",
        "TABLE",
        "THEAD",
        "TBODY",
        "TFOOT",
        "TH",
        "TD",
        "IFRAME",
        "SCRIPT",
        "AUDIO",
        "VIDEO"
      ];
      function H(e) {
        return A(e, C);
      }
      function F(e) {
        return R(e, C);
      }
      function A(e, r) {
        return r.indexOf(e.nodeName) >= 0;
      }
      function R(e, r) {
        return e.getElementsByTagName && r.some(function(t) {
          return e.getElementsByTagName(t).length;
        });
      }
      var s = {};
      s.paragraph = {
        filter: "p",
        replacement: function(e) {
          return `

` + e + `

`;
        }
      }, s.lineBreak = {
        filter: "br",
        replacement: function(e, r, t) {
          return t.br + `
`;
        }
      }, s.heading = {
        filter: ["h1", "h2", "h3", "h4", "h5", "h6"],
        replacement: function(e, r, t) {
          var n = Number(r.nodeName.charAt(1));
          if (t.headingStyle === "setext" && n < 3) {
            var i = h(n === 1 ? "=" : "-", e.length);
            return `

` + e + `
` + i + `

`;
          } else
            return `

` + h("#", n) + " " + e + `

`;
        }
      }, s.blockquote = {
        filter: "blockquote",
        replacement: function(e) {
          return e = e.replace(/^\n+|\n+$/g, ""), e = e.replace(/^/gm, "> "), `

` + e + `

`;
        }
      }, s.list = {
        filter: ["ul", "ol"],
        replacement: function(e, r) {
          var t = r.parentNode;
          return t.nodeName === "LI" && t.lastElementChild === r ? `
` + e : `

` + e + `

`;
        }
      }, s.listItem = {
        filter: "li",
        replacement: function(e, r, t) {
          var n = t.bulletListMarker + "   ", i = r.parentNode;
          if (i.nodeName === "OL") {
            var a = i.getAttribute("start"), o = Array.prototype.indexOf.call(i.children, r);
            n = (a ? Number(a) + o : o + 1) + ".  ";
          }
          return e = e.replace(/^\n+/, "").replace(/\n+$/, `
`).replace(/\n/gm, `
` + " ".repeat(n.length)), n + e + (r.nextSibling && !/\n$/.test(e) ? `
` : "");
        }
      }, s.indentedCodeBlock = {
        filter: function(e, r) {
          return r.codeBlockStyle === "indented" && e.nodeName === "PRE" && e.firstChild && e.firstChild.nodeName === "CODE";
        },
        replacement: function(e, r, t) {
          return `

    ` + r.firstChild.textContent.replace(/\n/g, `
    `) + `

`;
        }
      }, s.fencedCodeBlock = {
        filter: function(e, r) {
          return r.codeBlockStyle === "fenced" && e.nodeName === "PRE" && e.firstChild && e.firstChild.nodeName === "CODE";
        },
        replacement: function(e, r, t) {
          for (var n = r.firstChild.getAttribute("class") || "", i = (n.match(/language-(\S+)/) || [null, ""])[1], a = r.firstChild.textContent, o = t.fence.charAt(0), u = 3, l = new RegExp("^" + o + "{3,}", "gm"), f; f = l.exec(a); )
            f[0].length >= u && (u = f[0].length + 1);
          var m = h(o, u);
          return `

` + m + i + `
` + a.replace(/\n$/, "") + `
` + m + `

`;
        }
      }, s.horizontalRule = {
        filter: "hr",
        replacement: function(e, r, t) {
          return `

` + t.hr + `

`;
        }
      }, s.inlineLink = {
        filter: function(e, r) {
          return r.linkStyle === "inlined" && e.nodeName === "A" && e.getAttribute("href");
        },
        replacement: function(e, r) {
          var t = r.getAttribute("href");
          t && (t = t.replace(/([()])/g, "\\$1"));
          var n = p(r.getAttribute("title"));
          return n && (n = ' "' + n.replace(/"/g, '\\"') + '"'), "[" + e + "](" + t + n + ")";
        }
      }, s.referenceLink = {
        filter: function(e, r) {
          return r.linkStyle === "referenced" && e.nodeName === "A" && e.getAttribute("href");
        },
        replacement: function(e, r, t) {
          var n = r.getAttribute("href"), i = p(r.getAttribute("title"));
          i && (i = ' "' + i + '"');
          var a, o;
          switch (t.linkReferenceStyle) {
            case "collapsed":
              a = "[" + e + "][]", o = "[" + e + "]: " + n + i;
              break;
            case "shortcut":
              a = "[" + e + "]", o = "[" + e + "]: " + n + i;
              break;
            default:
              var u = this.references.length + 1;
              a = "[" + e + "][" + u + "]", o = "[" + u + "]: " + n + i;
          }
          return this.references.push(o), a;
        },
        references: [],
        append: function(e) {
          var r = "";
          return this.references.length && (r = `

` + this.references.join(`
`) + `

`, this.references = []), r;
        }
      }, s.emphasis = {
        filter: ["em", "i"],
        replacement: function(e, r, t) {
          return e.trim() ? t.emDelimiter + e + t.emDelimiter : "";
        }
      }, s.strong = {
        filter: ["strong", "b"],
        replacement: function(e, r, t) {
          return e.trim() ? t.strongDelimiter + e + t.strongDelimiter : "";
        }
      }, s.code = {
        filter: function(e) {
          var r = e.previousSibling || e.nextSibling, t = e.parentNode.nodeName === "PRE" && !r;
          return e.nodeName === "CODE" && !t;
        },
        replacement: function(e) {
          if (!e) return "";
          e = e.replace(/\r?\n|\r/g, " ");
          for (var r = /^`|^ .*?[^ ].* $|`$/.test(e) ? " " : "", t = "`", n = e.match(/`+/gm) || []; n.indexOf(t) !== -1; ) t = t + "`";
          return t + r + e + r + t;
        }
      }, s.image = {
        filter: "img",
        replacement: function(e, r) {
          var t = p(r.getAttribute("alt")), n = r.getAttribute("src") || "", i = p(r.getAttribute("title")), a = i ? ' "' + i + '"' : "";
          return n ? "![" + t + "](" + n + a + ")" : "";
        }
      };
      function p(e) {
        return e ? e.replace(/(\n+\s*)+/g, `
`) : "";
      }
      function O(e) {
        this.options = e, this._keep = [], this._remove = [], this.blankRule = {
          replacement: e.blankReplacement
        }, this.keepReplacement = e.keepReplacement, this.defaultRule = {
          replacement: e.defaultReplacement
        }, this.array = [];
        for (var r in e.rules) this.array.push(e.rules[r]);
      }
      O.prototype = {
        add: function(e, r) {
          this.array.unshift(r);
        },
        keep: function(e) {
          this._keep.unshift({
            filter: e,
            replacement: this.keepReplacement
          });
        },
        remove: function(e) {
          this._remove.unshift({
            filter: e,
            replacement: function() {
              return "";
            }
          });
        },
        forNode: function(e) {
          if (e.isBlank) return this.blankRule;
          var r;
          return (r = N(this.array, e, this.options)) || (r = N(this._keep, e, this.options)) || (r = N(this._remove, e, this.options)) ? r : this.defaultRule;
        },
        forEach: function(e) {
          for (var r = 0; r < this.array.length; r++) e(this.array[r], r);
        }
      };
      function N(e, r, t) {
        for (var n = 0; n < e.length; n++) {
          var i = e[n];
          if ($(i, r, t)) return i;
        }
      }
      function $(e, r, t) {
        var n = e.filter;
        if (typeof n == "string") {
          if (n === r.nodeName.toLowerCase()) return !0;
        } else if (Array.isArray(n)) {
          if (n.indexOf(r.nodeName.toLowerCase()) > -1) return !0;
        } else if (typeof n == "function") {
          if (n.call(e, r, t)) return !0;
        } else
          throw new TypeError("`filter` needs to be a string, array, or function");
      }
      function V(e) {
        var r = e.element, t = e.isBlock, n = e.isVoid, i = e.isPre || function(ie) {
          return ie.nodeName === "PRE";
        };
        if (!(!r.firstChild || i(r))) {
          for (var a = null, o = !1, u = null, l = S(u, r, i); l !== r; ) {
            if (l.nodeType === 3 || l.nodeType === 4) {
              var f = l.data.replace(/[ \r\n\t]+/g, " ");
              if ((!a || / $/.test(a.data)) && !o && f[0] === " " && (f = f.substr(1)), !f) {
                l = y(l);
                continue;
              }
              l.data = f, a = l;
            } else if (l.nodeType === 1)
              t(l) || l.nodeName === "BR" ? (a && (a.data = a.data.replace(/ $/, "")), a = null, o = !1) : n(l) || i(l) ? (a = null, o = !0) : a && (o = !1);
            else {
              l = y(l);
              continue;
            }
            var m = S(u, l, i);
            u = l, l = m;
          }
          a && (a.data = a.data.replace(/ $/, ""), a.data || y(a));
        }
      }
      function y(e) {
        var r = e.nextSibling || e.parentNode;
        return e.parentNode.removeChild(e), r;
      }
      function S(e, r, t) {
        return e && e.parentNode === r || t(r) ? r.nextSibling || r.parentNode : r.firstChild || r.nextSibling || r.parentNode;
      }
      var E = typeof window < "u" ? window : {};
      function U() {
        var e = E.DOMParser, r = !1;
        try {
          new e().parseFromString("", "text/html") && (r = !0);
        } catch {
        }
        return r;
      }
      function W() {
        var e = function() {
        };
        return j() ? e.prototype.parseFromString = function(r) {
          var t = new window.ActiveXObject("htmlfile");
          return t.designMode = "on", t.open(), t.write(r), t.close(), t;
        } : e.prototype.parseFromString = function(r) {
          var t = document.implementation.createHTMLDocument("");
          return t.open(), t.write(r), t.close(), t;
        }, e;
      }
      function j() {
        var e = !1;
        try {
          document.implementation.createHTMLDocument("").open();
        } catch {
          E.ActiveXObject && (e = !0);
        }
        return e;
      }
      var G = U() ? E.DOMParser : W();
      function X(e, r) {
        var t;
        if (typeof e == "string") {
          var n = q().parseFromString(
            // DOM parsers arrange elements in the <head> and <body>.
            // Wrapping in a custom element ensures elements are reliably arranged in
            // a single element.
            '<x-turndown id="turndown-root">' + e + "</x-turndown>",
            "text/html"
          );
          t = n.getElementById("turndown-root");
        } else
          t = e.cloneNode(!0);
        return V({
          element: t,
          isBlock: v,
          isVoid: w,
          isPre: r.preformattedCode ? K : null
        }), t;
      }
      var T;
      function q() {
        return T = T || new G(), T;
      }
      function K(e) {
        return e.nodeName === "PRE" || e.nodeName === "CODE";
      }
      function Y(e, r) {
        return e.isBlock = v(e), e.isCode = e.nodeName === "CODE" || e.parentNode.isCode, e.isBlank = z(e), e.flankingWhitespace = Q(e, r), e;
      }
      function z(e) {
        return !w(e) && !H(e) && /^\s*$/i.test(e.textContent) && !_(e) && !F(e);
      }
      function Q(e, r) {
        if (e.isBlock || r.preformattedCode && e.isCode)
          return { leading: "", trailing: "" };
        var t = J(e.textContent);
        return t.leadingAscii && D("left", e, r) && (t.leading = t.leadingNonAscii), t.trailingAscii && D("right", e, r) && (t.trailing = t.trailingNonAscii), { leading: t.leading, trailing: t.trailing };
      }
      function J(e) {
        var r = e.match(/^(([ \t\r\n]*)(\s*))(?:(?=\S)[\s\S]*\S)?((\s*?)([ \t\r\n]*))$/);
        return {
          leading: r[1],
          // whole string for whitespace-only strings
          leadingAscii: r[2],
          leadingNonAscii: r[3],
          trailing: r[4],
          // empty for whitespace-only strings
          trailingNonAscii: r[5],
          trailingAscii: r[6]
        };
      }
      function D(e, r, t) {
        var n, i, a;
        return e === "left" ? (n = r.previousSibling, i = / $/) : (n = r.nextSibling, i = /^ /), n && (n.nodeType === 3 ? a = i.test(n.nodeValue) : t.preformattedCode && n.nodeName === "CODE" ? a = !1 : n.nodeType === 1 && !v(n) && (a = i.test(n.textContent))), a;
      }
      var Z = Array.prototype.reduce, ee = [
        [/\\/g, "\\\\"],
        [/\*/g, "\\*"],
        [/^-/g, "\\-"],
        [/^\+ /g, "\\+ "],
        [/^(=+)/g, "\\$1"],
        [/^(#{1,6}) /g, "\\$1 "],
        [/`/g, "\\`"],
        [/^~~~/g, "\\~~~"],
        [/\[/g, "\\["],
        [/\]/g, "\\]"],
        [/^>/g, "\\>"],
        [/_/g, "\\_"],
        [/^(\d+)\. /g, "$1\\. "]
      ];
      function d(e) {
        if (!(this instanceof d)) return new d(e);
        var r = {
          rules: s,
          headingStyle: "setext",
          hr: "* * *",
          bulletListMarker: "*",
          codeBlockStyle: "indented",
          fence: "```",
          emDelimiter: "_",
          strongDelimiter: "**",
          linkStyle: "inlined",
          linkReferenceStyle: "full",
          br: "  ",
          preformattedCode: !1,
          blankReplacement: function(t, n) {
            return n.isBlock ? `

` : "";
          },
          keepReplacement: function(t, n) {
            return n.isBlock ? `

` + n.outerHTML + `

` : n.outerHTML;
          },
          defaultReplacement: function(t, n) {
            return n.isBlock ? `

` + t + `

` : t;
          }
        };
        this.options = k({}, r, e), this.rules = new O(this.options);
      }
      d.prototype = {
        /**
         * The entry point for converting a string or DOM node to Markdown
         * @public
         * @param {String|HTMLElement} input The string or DOM node to convert
         * @returns A Markdown representation of the input
         * @type String
         */
        turndown: function(e) {
          if (!ne(e))
            throw new TypeError(
              e + " is not a string, or an element/document/fragment node."
            );
          if (e === "") return "";
          var r = B.call(this, new X(e, this.options));
          return re.call(this, r);
        },
        /**
         * Add one or more plugins
         * @public
         * @param {Function|Array} plugin The plugin or array of plugins to add
         * @returns The Turndown instance for chaining
         * @type Object
         */
        use: function(e) {
          if (Array.isArray(e))
            for (var r = 0; r < e.length; r++) this.use(e[r]);
          else if (typeof e == "function")
            e(this);
          else
            throw new TypeError("plugin must be a Function or an Array of Functions");
          return this;
        },
        /**
         * Adds a rule
         * @public
         * @param {String} key The unique key of the rule
         * @param {Object} rule The rule
         * @returns The Turndown instance for chaining
         * @type Object
         */
        addRule: function(e, r) {
          return this.rules.add(e, r), this;
        },
        /**
         * Keep a node (as HTML) that matches the filter
         * @public
         * @param {String|Array|Function} filter The unique key of the rule
         * @returns The Turndown instance for chaining
         * @type Object
         */
        keep: function(e) {
          return this.rules.keep(e), this;
        },
        /**
         * Remove a node that matches the filter
         * @public
         * @param {String|Array|Function} filter The unique key of the rule
         * @returns The Turndown instance for chaining
         * @type Object
         */
        remove: function(e) {
          return this.rules.remove(e), this;
        },
        /**
         * Escapes Markdown syntax
         * @public
         * @param {String} string The string to escape
         * @returns A string with Markdown syntax escaped
         * @type String
         */
        escape: function(e) {
          return ee.reduce(function(r, t) {
            return r.replace(t[0], t[1]);
          }, e);
        }
      };
      function B(e) {
        var r = this;
        return Z.call(e.childNodes, function(t, n) {
          n = new Y(n, r.options);
          var i = "";
          return n.nodeType === 3 ? i = n.isCode ? n.nodeValue : r.escape(n.nodeValue) : n.nodeType === 1 && (i = te.call(r, n)), x(t, i);
        }, "");
      }
      function re(e) {
        var r = this;
        return this.rules.forEach(function(t) {
          typeof t.append == "function" && (e = x(e, t.append(r.options)));
        }), e.replace(/^[\t\r\n]+/, "").replace(/[\t\r\n\s]+$/, "");
      }
      function te(e) {
        var r = this.rules.forNode(e), t = B.call(this, e), n = e.flankingWhitespace;
        return (n.leading || n.trailing) && (t = t.trim()), n.leading + r.replacement(t, e, this.options) + n.trailing;
      }
      function x(e, r) {
        var t = M(e), n = L(r), i = Math.max(e.length - t.length, r.length - n.length), a = `

`.substring(0, i);
        return t + a + n;
      }
      function ne(e) {
        return e != null && (typeof e == "string" || e.nodeType && (e.nodeType === 1 || e.nodeType === 9 || e.nodeType === 11));
      }
      return d;
    });
  }(g)), g.exports;
}
var oe = se();
const fe = /* @__PURE__ */ ae(oe);
export {
  fe as default
};
