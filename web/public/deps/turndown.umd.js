(function(h,c){typeof exports=="object"&&typeof module<"u"?module.exports=c():typeof define=="function"&&define.amd?define(c):(h=typeof globalThis<"u"?globalThis:h||self,h.TurndownService=c())})(this,function(){"use strict";function h(d){return d&&d.__esModule&&Object.prototype.hasOwnProperty.call(d,"default")?d.default:d}var c={exports:{}},M=c.exports,k;function I(){return k||(k=1,function(d,fe){(function(w,p){d.exports=p()})(M,function(){function w(e){for(var r=1;r<arguments.length;r++){var t=arguments[r];for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n])}return e}function p(e,r){return Array(r+1).join(e)}function H(e){return e.replace(/^\n*/,"")}function F(e){for(var r=e.length;r>0&&e[r-1]===`
`;)r--;return e.substring(0,r)}var $=["ADDRESS","ARTICLE","ASIDE","AUDIO","BLOCKQUOTE","BODY","CANVAS","CENTER","DD","DIR","DIV","DL","DT","FIELDSET","FIGCAPTION","FIGURE","FOOTER","FORM","FRAMESET","H1","H2","H3","H4","H5","H6","HEADER","HGROUP","HR","HTML","ISINDEX","LI","MAIN","MENU","NAV","NOFRAMES","NOSCRIPT","OL","OUTPUT","P","PRE","SECTION","TABLE","TBODY","TD","TFOOT","TH","THEAD","TR","UL"];function y(e){return A(e,$)}var C=["AREA","BASE","BR","COL","COMMAND","EMBED","HR","IMG","INPUT","KEYGEN","LINK","META","PARAM","SOURCE","TRACK","WBR"];function R(e){return A(e,C)}function V(e){return S(e,C)}var O=["A","TABLE","THEAD","TBODY","TFOOT","TH","TD","IFRAME","SCRIPT","AUDIO","VIDEO"];function U(e){return A(e,O)}function W(e){return S(e,O)}function A(e,r){return r.indexOf(e.nodeName)>=0}function S(e,r){return e.getElementsByTagName&&r.some(function(t){return e.getElementsByTagName(t).length})}var o={};o.paragraph={filter:"p",replacement:function(e){return`

`+e+`

`}},o.lineBreak={filter:"br",replacement:function(e,r,t){return t.br+`
`}},o.heading={filter:["h1","h2","h3","h4","h5","h6"],replacement:function(e,r,t){var n=Number(r.nodeName.charAt(1));if(t.headingStyle==="setext"&&n<3){var i=p(n===1?"=":"-",e.length);return`

`+e+`
`+i+`

`}else return`

`+p("#",n)+" "+e+`

`}},o.blockquote={filter:"blockquote",replacement:function(e){return e=e.replace(/^\n+|\n+$/g,""),e=e.replace(/^/gm,"> "),`

`+e+`

`}},o.list={filter:["ul","ol"],replacement:function(e,r){var t=r.parentNode;return t.nodeName==="LI"&&t.lastElementChild===r?`
`+e:`

`+e+`

`}},o.listItem={filter:"li",replacement:function(e,r,t){var n=t.bulletListMarker+"   ",i=r.parentNode;if(i.nodeName==="OL"){var a=i.getAttribute("start"),s=Array.prototype.indexOf.call(i.children,r);n=(a?Number(a)+s:s+1)+".  "}return e=e.replace(/^\n+/,"").replace(/\n+$/,`
`).replace(/\n/gm,`
`+" ".repeat(n.length)),n+e+(r.nextSibling&&!/\n$/.test(e)?`
`:"")}},o.indentedCodeBlock={filter:function(e,r){return r.codeBlockStyle==="indented"&&e.nodeName==="PRE"&&e.firstChild&&e.firstChild.nodeName==="CODE"},replacement:function(e,r,t){return`

    `+r.firstChild.textContent.replace(/\n/g,`
    `)+`

`}},o.fencedCodeBlock={filter:function(e,r){return r.codeBlockStyle==="fenced"&&e.nodeName==="PRE"&&e.firstChild&&e.firstChild.nodeName==="CODE"},replacement:function(e,r,t){for(var n=r.firstChild.getAttribute("class")||"",i=(n.match(/language-(\S+)/)||[null,""])[1],a=r.firstChild.textContent,s=t.fence.charAt(0),u=3,l=new RegExp("^"+s+"{3,}","gm"),f;f=l.exec(a);)f[0].length>=u&&(u=f[0].length+1);var v=p(s,u);return`

`+v+i+`
`+a.replace(/\n$/,"")+`
`+v+`

`}},o.horizontalRule={filter:"hr",replacement:function(e,r,t){return`

`+t.hr+`

`}},o.inlineLink={filter:function(e,r){return r.linkStyle==="inlined"&&e.nodeName==="A"&&e.getAttribute("href")},replacement:function(e,r){var t=r.getAttribute("href");t&&(t=t.replace(/([()])/g,"\\$1"));var n=m(r.getAttribute("title"));return n&&(n=' "'+n.replace(/"/g,'\\"')+'"'),"["+e+"]("+t+n+")"}},o.referenceLink={filter:function(e,r){return r.linkStyle==="referenced"&&e.nodeName==="A"&&e.getAttribute("href")},replacement:function(e,r,t){var n=r.getAttribute("href"),i=m(r.getAttribute("title"));i&&(i=' "'+i+'"');var a,s;switch(t.linkReferenceStyle){case"collapsed":a="["+e+"][]",s="["+e+"]: "+n+i;break;case"shortcut":a="["+e+"]",s="["+e+"]: "+n+i;break;default:var u=this.references.length+1;a="["+e+"]["+u+"]",s="["+u+"]: "+n+i}return this.references.push(s),a},references:[],append:function(e){var r="";return this.references.length&&(r=`

`+this.references.join(`
`)+`

`,this.references=[]),r}},o.emphasis={filter:["em","i"],replacement:function(e,r,t){return e.trim()?t.emDelimiter+e+t.emDelimiter:""}},o.strong={filter:["strong","b"],replacement:function(e,r,t){return e.trim()?t.strongDelimiter+e+t.strongDelimiter:""}},o.code={filter:function(e){var r=e.previousSibling||e.nextSibling,t=e.parentNode.nodeName==="PRE"&&!r;return e.nodeName==="CODE"&&!t},replacement:function(e){if(!e)return"";e=e.replace(/\r?\n|\r/g," ");for(var r=/^`|^ .*?[^ ].* $|`$/.test(e)?" ":"",t="`",n=e.match(/`+/gm)||[];n.indexOf(t)!==-1;)t=t+"`";return t+r+e+r+t}},o.image={filter:"img",replacement:function(e,r){var t=m(r.getAttribute("alt")),n=r.getAttribute("src")||"",i=m(r.getAttribute("title")),a=i?' "'+i+'"':"";return n?"!["+t+"]("+n+a+")":""}};function m(e){return e?e.replace(/(\n+\s*)+/g,`
`):""}function D(e){this.options=e,this._keep=[],this._remove=[],this.blankRule={replacement:e.blankReplacement},this.keepReplacement=e.keepReplacement,this.defaultRule={replacement:e.defaultReplacement},this.array=[];for(var r in e.rules)this.array.push(e.rules[r])}D.prototype={add:function(e,r){this.array.unshift(r)},keep:function(e){this._keep.unshift({filter:e,replacement:this.keepReplacement})},remove:function(e){this._remove.unshift({filter:e,replacement:function(){return""}})},forNode:function(e){if(e.isBlank)return this.blankRule;var r;return(r=T(this.array,e,this.options))||(r=T(this._keep,e,this.options))||(r=T(this._remove,e,this.options))?r:this.defaultRule},forEach:function(e){for(var r=0;r<this.array.length;r++)e(this.array[r],r)}};function T(e,r,t){for(var n=0;n<e.length;n++){var i=e[n];if(j(i,r,t))return i}}function j(e,r,t){var n=e.filter;if(typeof n=="string"){if(n===r.nodeName.toLowerCase())return!0}else if(Array.isArray(n)){if(n.indexOf(r.nodeName.toLowerCase())>-1)return!0}else if(typeof n=="function"){if(n.call(e,r,t))return!0}else throw new TypeError("`filter` needs to be a string, array, or function")}function G(e){var r=e.element,t=e.isBlock,n=e.isVoid,i=e.isPre||function(se){return se.nodeName==="PRE"};if(!(!r.firstChild||i(r))){for(var a=null,s=!1,u=null,l=B(u,r,i);l!==r;){if(l.nodeType===3||l.nodeType===4){var f=l.data.replace(/[ \r\n\t]+/g," ");if((!a||/ $/.test(a.data))&&!s&&f[0]===" "&&(f=f.substr(1)),!f){l=N(l);continue}l.data=f,a=l}else if(l.nodeType===1)t(l)||l.nodeName==="BR"?(a&&(a.data=a.data.replace(/ $/,"")),a=null,s=!1):n(l)||i(l)?(a=null,s=!0):a&&(s=!1);else{l=N(l);continue}var v=B(u,l,i);u=l,l=v}a&&(a.data=a.data.replace(/ $/,""),a.data||N(a))}}function N(e){var r=e.nextSibling||e.parentNode;return e.parentNode.removeChild(e),r}function B(e,r,t){return e&&e.parentNode===r||t(r)?r.nextSibling||r.parentNode:r.firstChild||r.nextSibling||r.parentNode}var E=typeof window<"u"?window:{};function X(){var e=E.DOMParser,r=!1;try{new e().parseFromString("","text/html")&&(r=!0)}catch{}return r}function q(){var e=function(){};return K()?e.prototype.parseFromString=function(r){var t=new window.ActiveXObject("htmlfile");return t.designMode="on",t.open(),t.write(r),t.close(),t}:e.prototype.parseFromString=function(r){var t=document.implementation.createHTMLDocument("");return t.open(),t.write(r),t.close(),t},e}function K(){var e=!1;try{document.implementation.createHTMLDocument("").open()}catch{E.ActiveXObject&&(e=!0)}return e}var Y=X()?E.DOMParser:q();function z(e,r){var t;if(typeof e=="string"){var n=Q().parseFromString('<x-turndown id="turndown-root">'+e+"</x-turndown>","text/html");t=n.getElementById("turndown-root")}else t=e.cloneNode(!0);return G({element:t,isBlock:y,isVoid:R,isPre:r.preformattedCode?J:null}),t}var b;function Q(){return b=b||new Y,b}function J(e){return e.nodeName==="PRE"||e.nodeName==="CODE"}function Z(e,r){return e.isBlock=y(e),e.isCode=e.nodeName==="CODE"||e.parentNode.isCode,e.isBlank=ee(e),e.flankingWhitespace=re(e,r),e}function ee(e){return!R(e)&&!U(e)&&/^\s*$/i.test(e.textContent)&&!V(e)&&!W(e)}function re(e,r){if(e.isBlock||r.preformattedCode&&e.isCode)return{leading:"",trailing:""};var t=te(e.textContent);return t.leadingAscii&&x("left",e,r)&&(t.leading=t.leadingNonAscii),t.trailingAscii&&x("right",e,r)&&(t.trailing=t.trailingNonAscii),{leading:t.leading,trailing:t.trailing}}function te(e){var r=e.match(/^(([ \t\r\n]*)(\s*))(?:(?=\S)[\s\S]*\S)?((\s*?)([ \t\r\n]*))$/);return{leading:r[1],leadingAscii:r[2],leadingNonAscii:r[3],trailing:r[4],trailingNonAscii:r[5],trailingAscii:r[6]}}function x(e,r,t){var n,i,a;return e==="left"?(n=r.previousSibling,i=/ $/):(n=r.nextSibling,i=/^ /),n&&(n.nodeType===3?a=i.test(n.nodeValue):t.preformattedCode&&n.nodeName==="CODE"?a=!1:n.nodeType===1&&!y(n)&&(a=i.test(n.textContent))),a}var ne=Array.prototype.reduce,ie=[[/\\/g,"\\\\"],[/\*/g,"\\*"],[/^-/g,"\\-"],[/^\+ /g,"\\+ "],[/^(=+)/g,"\\$1"],[/^(#{1,6}) /g,"\\$1 "],[/`/g,"\\`"],[/^~~~/g,"\\~~~"],[/\[/g,"\\["],[/\]/g,"\\]"],[/^>/g,"\\>"],[/_/g,"\\_"],[/^(\d+)\. /g,"$1\\. "]];function g(e){if(!(this instanceof g))return new g(e);var r={rules:o,headingStyle:"setext",hr:"* * *",bulletListMarker:"*",codeBlockStyle:"indented",fence:"```",emDelimiter:"_",strongDelimiter:"**",linkStyle:"inlined",linkReferenceStyle:"full",br:"  ",preformattedCode:!1,blankReplacement:function(t,n){return n.isBlock?`

`:""},keepReplacement:function(t,n){return n.isBlock?`

`+n.outerHTML+`

`:n.outerHTML},defaultReplacement:function(t,n){return n.isBlock?`

`+t+`

`:t}};this.options=w({},r,e),this.rules=new D(this.options)}g.prototype={turndown:function(e){if(!oe(e))throw new TypeError(e+" is not a string, or an element/document/fragment node.");if(e==="")return"";var r=P.call(this,new z(e,this.options));return ae.call(this,r)},use:function(e){if(Array.isArray(e))for(var r=0;r<e.length;r++)this.use(e[r]);else if(typeof e=="function")e(this);else throw new TypeError("plugin must be a Function or an Array of Functions");return this},addRule:function(e,r){return this.rules.add(e,r),this},keep:function(e){return this.rules.keep(e),this},remove:function(e){return this.rules.remove(e),this},escape:function(e){return ie.reduce(function(r,t){return r.replace(t[0],t[1])},e)}};function P(e){var r=this;return ne.call(e.childNodes,function(t,n){n=new Z(n,r.options);var i="";return n.nodeType===3?i=n.isCode?n.nodeValue:r.escape(n.nodeValue):n.nodeType===1&&(i=le.call(r,n)),L(t,i)},"")}function ae(e){var r=this;return this.rules.forEach(function(t){typeof t.append=="function"&&(e=L(e,t.append(r.options)))}),e.replace(/^[\t\r\n]+/,"").replace(/[\t\r\n\s]+$/,"")}function le(e){var r=this.rules.forNode(e),t=P.call(this,e),n=e.flankingWhitespace;return(n.leading||n.trailing)&&(t=t.trim()),n.leading+r.replacement(t,e,this.options)+n.trailing}function L(e,r){var t=F(e),n=H(r),i=Math.max(e.length-t.length,r.length-n.length),a=`

`.substring(0,i);return t+a+n}function oe(e){return e!=null&&(typeof e=="string"||e.nodeType&&(e.nodeType===1||e.nodeType===9||e.nodeType===11))}return g})}(c)),c.exports}var _=I();return h(_)});
