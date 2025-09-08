function P(i) {
  return i && i.__esModule && Object.prototype.hasOwnProperty.call(i, "default") ? i.default : i;
}
var T = {}, k;
function D() {
  return k || (k = 1, function(i) {
    var d = /highlight-(?:text|source)-([a-z0-9]+)/;
    function h(t) {
      t.addRule("highlightedCodeBlock", {
        filter: function(e) {
          var r = e.firstChild;
          return e.nodeName === "DIV" && d.test(e.className) && r && r.nodeName === "PRE";
        },
        replacement: function(e, r, l) {
          var n = r.className || "", u = (n.match(d) || [null, ""])[1];
          return `

` + l.fence + u + `
` + r.firstChild.textContent + `
` + l.fence + `

`;
        }
      });
    }
    function g(t) {
      t.addRule("strikethrough", {
        filter: ["del", "s", "strike"],
        replacement: function(e) {
          return "~" + e + "~";
        }
      });
    }
    var L = Array.prototype.indexOf, y = Array.prototype.every, a = {};
    a.tableCell = {
      filter: ["th", "td"],
      replacement: function(t, e) {
        return c(m(e)) ? t : f(t, e);
      }
    }, a.tableRow = {
      filter: "tr",
      replacement: function(t, e) {
        const r = m(e);
        if (c(r)) return t;
        var l = "", n = { left: ":--", right: "--:", center: ":-:" };
        if (A(e)) {
          const b = N(r);
          for (var u = 0; u < b; u++) {
            const s = b >= e.childNodes.length ? null : e.childNodes[u];
            var o = "---", w = s ? (s.getAttribute("align") || "").toLowerCase() : "";
            w && (o = n[w] || o), s ? l += f(o, e.childNodes[u]) : l += f(o, null, u);
          }
        }
        return `
` + t + (l ? `
` + l : "");
      }
    }, a.table = {
      // Only convert tables with a heading row.
      // Tables with no heading row are kept using `keep` (see below).
      filter: function(t) {
        return t.nodeName === "TABLE";
      },
      replacement: function(t, e) {
        if (c(e)) return t;
        t = t.replace(/\n+/g, `
`);
        var r = t.trim().split(`
`);
        r.length >= 2 && (r = r[1]);
        var l = r.indexOf("| ---") === 0, n = N(e), u = "";
        return n && !l && (u = "|" + "     |".repeat(n) + `
|` + " --- |".repeat(n)), `

` + u + t + `

`;
      }
    }, a.tableSection = {
      filter: ["thead", "tbody", "tfoot"],
      replacement: function(t) {
        return t;
      }
    };
    function A(t) {
      var e = t.parentNode;
      return e.nodeName === "THEAD" || e.firstChild === t && (e.nodeName === "TABLE" || E(e)) && y.call(t.childNodes, function(r) {
        return r.nodeName === "TH";
      });
    }
    function E(t) {
      var e = t.previousSibling;
      return t.nodeName === "TBODY" && (!e || e.nodeName === "THEAD" && /^\s*$/i.test(e.textContent));
    }
    function f(t, e = null, r = null) {
      r === null && (r = L.call(e.parentNode.childNodes, e));
      var l = " ";
      r === 0 && (l = "| ");
      let n = t.trim().replace(/\n\r/g, "<br>").replace(/\n/g, "<br>");
      for (n = n.replace(/\|+/g, "\\|"); n.length < 3; ) n += " ";
      return e && (n = B(n, e, " ")), l + n + " |";
    }
    function p(t) {
      if (!t.childNodes) return !1;
      for (let e = 0; e < t.childNodes.length; e++) {
        const r = t.childNodes[e];
        if (r.nodeName === "TABLE" || p(r)) return !0;
      }
      return !1;
    }
    function c(t) {
      return !!(!t || !t.rows || t.rows.length === 1 && t.rows[0].childNodes.length <= 1 || p(t));
    }
    function m(t) {
      let e = t.parentNode;
      for (; e.nodeName !== "TABLE"; )
        if (e = e.parentNode, !e) return null;
      return e;
    }
    function B(t, e, r) {
      const l = e.getAttribute("colspan") || 1;
      for (let n = 1; n < l; n++)
        t += " | " + r.repeat(3);
      return t;
    }
    function N(t) {
      let e = 0;
      for (let r = 0; r < t.rows.length; r++) {
        const n = t.rows[r].childNodes.length;
        n > e && (e = n);
      }
      return e;
    }
    function v(t) {
      t.keep(function(r) {
        return r.nodeName === "TABLE";
      });
      for (var e in a) t.addRule(e, a[e]);
    }
    function C(t) {
      t.addRule("taskListItems", {
        filter: function(e) {
          return e.type === "checkbox" && e.parentNode.nodeName === "LI";
        },
        replacement: function(e, r) {
          return (r.checked ? "[x]" : "[ ]") + " ";
        }
      });
    }
    function R(t) {
      t.use([
        h,
        g,
        v,
        C
      ]);
    }
    return i.gfm = R, i.highlightedCodeBlock = h, i.strikethrough = g, i.tables = v, i.taskListItems = C, i;
  }({})), T;
}
var I = D();
const O = /* @__PURE__ */ P(I);
export {
  O as default
};
