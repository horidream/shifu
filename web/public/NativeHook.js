(function(Z){typeof define=="function"&&define.amd?define(Z):Z()})(function(){"use strict";var Z={NODE_ENV:'"production"'};/**
* @vue/shared v3.4.15
* (c) 2018-present Yuxi (Evan) You and Vue contributors
* @license MIT
**/function Ct(e,t){const n=new Set(e.split(","));return t?r=>n.has(r.toLowerCase()):r=>n.has(r)}const $=Z.NODE_ENV!=="production"?Object.freeze({}):{},D=()=>{},P=Object.assign,jt=Object.prototype.hasOwnProperty,p=(e,t)=>jt.call(e,t),g=Array.isArray,N=e=>ee(e)==="[object Map]",At=e=>ee(e)==="[object Set]",b=e=>typeof e=="function",we=e=>typeof e=="string",k=e=>typeof e=="symbol",C=e=>e!==null&&typeof e=="object",Ht=e=>(C(e)||b(e))&&b(e.then)&&b(e.catch),Lt=Object.prototype.toString,ee=e=>Lt.call(e),Ge=e=>ee(e).slice(8,-1),Vt=e=>ee(e)==="[object Object]",be=e=>we(e)&&e!=="NaN"&&e[0]!=="-"&&""+parseInt(e,10)===e,Kt=(e=>{const t=Object.create(null);return n=>t[n]||(t[n]=e(n))})(e=>e.charAt(0).toUpperCase()+e.slice(1)),U=(e,t)=>!Object.is(e,t),Nt=(e,t,n)=>{Object.defineProperty(e,t,{configurable:!0,enumerable:!1,value:n})};let Je;const Be=()=>Je||(Je=typeof globalThis<"u"?globalThis:typeof self<"u"?self:typeof window<"u"?window:typeof global<"u"?global:{});function Ye(e,...t){console.warn(`[Vue warn] ${e}`,...t)}let Ut;function Ft(e,t=Ut){t&&t.active&&t.effects.push(e)}let q;class Wt{constructor(t,n,r,s){this.fn=t,this.trigger=n,this.scheduler=r,this.active=!0,this.deps=[],this._dirtyLevel=2,this._trackId=0,this._runnings=0,this._shouldSchedule=!1,this._depsLength=0,Ft(this,s)}get dirty(){if(this._dirtyLevel===1){Se();for(let t=0;t<this._depsLength;t++){const n=this.deps[t];if(n.computed&&(zt(n.computed),this._dirtyLevel>=2))break}this._dirtyLevel<2&&(this._dirtyLevel=0),ve()}return this._dirtyLevel>=2}set dirty(t){this._dirtyLevel=t?2:0}run(){if(this._dirtyLevel=0,!this.active)return this.fn();let t=j,n=q;try{return j=!0,q=this,this._runnings++,Qe(this),this.fn()}finally{Xe(this),this._runnings--,q=n,j=t}}stop(){var t;this.active&&(Qe(this),Xe(this),(t=this.onStop)==null||t.call(this),this.active=!1)}}function zt(e){return e.value}function Qe(e){e._trackId++,e._depsLength=0}function Xe(e){if(e.deps&&e.deps.length>e._depsLength){for(let t=e._depsLength;t<e.deps.length;t++)Ze(e.deps[t],e);e.deps.length=e._depsLength}}function Ze(e,t){const n=e.get(t);n!==void 0&&t._trackId!==n&&(e.delete(t),e.size===0&&e.cleanup())}let j=!0,me=0;const ke=[];function Se(){ke.push(j),j=!1}function ve(){const e=ke.pop();j=e===void 0?!0:e}function Ee(){me++}function xe(){for(me--;!me&&Ie.length;)Ie.shift()()}function Dt(e,t,n){var r;if(t.get(e)!==e._trackId){t.set(e,e._trackId);const s=e.deps[e._depsLength];s!==t?(s&&Ze(s,e),e.deps[e._depsLength++]=t):e._depsLength++,(r=e.onTrack)==null||r.call(e,P({effect:e},n))}}const Ie=[];function qt(e,t,n){var r;Ee();for(const s of e.keys())if(s._dirtyLevel<t&&e.get(s)===s._trackId){const o=s._dirtyLevel;s._dirtyLevel=t,o===0&&(s._shouldSchedule=!0,(r=s.onTrigger)==null||r.call(s,P({effect:s},n)),s.trigger())}Gt(e),xe()}function Gt(e){for(const t of e.keys())t.scheduler&&t._shouldSchedule&&(!t._runnings||t.allowRecurse)&&e.get(t)===t._trackId&&(t._shouldSchedule=!1,Ie.push(t.scheduler))}const Jt=(e,t)=>{const n=new Map;return n.cleanup=e,n.computed=t,n},Pe=new WeakMap,A=Symbol("iterate"),Oe=Symbol("Map key iterate");function m(e,t,n){if(j&&q){let r=Pe.get(e);r||Pe.set(e,r=new Map);let s=r.get(n);s||r.set(n,s=Jt(()=>r.delete(n))),Dt(q,s,{target:e,type:t,key:n})}}function O(e,t,n,r,s,o){const i=Pe.get(e);if(!i)return;let c=[];if(t==="clear")c=[...i.values()];else if(n==="length"&&g(e)){const f=Number(r);i.forEach((l,h)=>{(h==="length"||!k(h)&&h>=f)&&c.push(l)})}else switch(n!==void 0&&c.push(i.get(n)),t){case"add":g(e)?be(n)&&c.push(i.get("length")):(c.push(i.get(A)),N(e)&&c.push(i.get(Oe)));break;case"delete":g(e)||(c.push(i.get(A)),N(e)&&c.push(i.get(Oe)));break;case"set":N(e)&&c.push(i.get(A));break}Ee();for(const f of c)f&&qt(f,2,{target:e,type:t,key:n,newValue:r,oldValue:s,oldTarget:o});xe()}const Bt=Ct("__proto__,__v_isRef,__isVue"),et=new Set(Object.getOwnPropertyNames(Symbol).filter(e=>e!=="arguments"&&e!=="caller").map(e=>Symbol[e]).filter(k)),tt=Yt();function Yt(){const e={};return["includes","indexOf","lastIndexOf"].forEach(t=>{e[t]=function(...n){const r=u(this);for(let o=0,i=this.length;o<i;o++)m(r,"get",o+"");const s=r[t](...n);return s===-1||s===!1?r[t](...n.map(u)):s}}),["push","pop","shift","unshift","splice"].forEach(t=>{e[t]=function(...n){Se(),Ee();const r=u(this)[t].apply(this,n);return xe(),ve(),r}}),e}function Qt(e){const t=u(this);return m(t,"has",e),t.hasOwnProperty(e)}class nt{constructor(t=!1,n=!1){this._isReadonly=t,this._shallow=n}get(t,n,r){const s=this._isReadonly,o=this._shallow;if(n==="__v_isReactive")return!s;if(n==="__v_isReadonly")return s;if(n==="__v_isShallow")return o;if(n==="__v_raw")return r===(s?o?ft:ut:o?un:at).get(t)||Object.getPrototypeOf(t)===Object.getPrototypeOf(r)?t:void 0;const i=g(t);if(!s){if(i&&p(tt,n))return Reflect.get(tt,n,r);if(n==="hasOwnProperty")return Qt}const c=Reflect.get(t,n,r);return(k(n)?et.has(n):Bt(n))||(s||m(t,"get",n),o)?c:x(c)?i&&be(n)?c:c.value:C(c)?s?dt(c):Te(c):c}}class Xt extends nt{constructor(t=!1){super(!1,t)}set(t,n,r,s){let o=t[n];if(!this._shallow){const f=le(o);if(!$e(r)&&!le(r)&&(o=u(o),r=u(r)),!g(t)&&x(o)&&!x(r))return f?!1:(o.value=r,!0)}const i=g(t)&&be(n)?Number(n)<t.length:p(t,n),c=Reflect.set(t,n,r,s);return t===u(s)&&(i?U(r,o)&&O(t,"set",n,r,o):O(t,"add",n,r)),c}deleteProperty(t,n){const r=p(t,n),s=t[n],o=Reflect.deleteProperty(t,n);return o&&r&&O(t,"delete",n,void 0,s),o}has(t,n){const r=Reflect.has(t,n);return(!k(n)||!et.has(n))&&m(t,"has",n),r}ownKeys(t){return m(t,"iterate",g(t)?"length":A),Reflect.ownKeys(t)}}class rt extends nt{constructor(t=!1){super(!0,t)}set(t,n){return Ye(`Set operation on key "${String(n)}" failed: target is readonly.`,t),!0}deleteProperty(t,n){return Ye(`Delete operation on key "${String(n)}" failed: target is readonly.`,t),!0}}const Zt=new Xt,kt=new rt,en=new rt(!0),Re=e=>e,te=e=>Reflect.getPrototypeOf(e);function ne(e,t,n=!1,r=!1){e=e.__v_raw;const s=u(e),o=u(t);n||(U(t,o)&&m(s,"get",t),m(s,"get",o));const{has:i}=te(s),c=r?Re:n?je:Ce;if(i.call(s,t))return c(e.get(t));if(i.call(s,o))return c(e.get(o));e!==s&&e.get(t)}function re(e,t=!1){const n=this.__v_raw,r=u(n),s=u(e);return t||(U(e,s)&&m(r,"has",e),m(r,"has",s)),e===s?n.has(e):n.has(e)||n.has(s)}function se(e,t=!1){return e=e.__v_raw,!t&&m(u(e),"iterate",A),Reflect.get(e,"size",e)}function st(e){e=u(e);const t=u(this);return te(t).has.call(t,e)||(t.add(e),O(t,"add",e,e)),this}function ot(e,t){t=u(t);const n=u(this),{has:r,get:s}=te(n);let o=r.call(n,e);o?lt(n,r,e):(e=u(e),o=r.call(n,e));const i=s.call(n,e);return n.set(e,t),o?U(t,i)&&O(n,"set",e,t,i):O(n,"add",e,t),this}function it(e){const t=u(this),{has:n,get:r}=te(t);let s=n.call(t,e);s?lt(t,n,e):(e=u(e),s=n.call(t,e));const o=r?r.call(t,e):void 0,i=t.delete(e);return s&&O(t,"delete",e,void 0,o),i}function ct(){const e=u(this),t=e.size!==0,n=N(e)?new Map(e):new Set(e),r=e.clear();return t&&O(e,"clear",void 0,void 0,n),r}function oe(e,t){return function(r,s){const o=this,i=o.__v_raw,c=u(i),f=t?Re:e?je:Ce;return!e&&m(c,"iterate",A),i.forEach((l,h)=>r.call(s,f(l),f(h),o))}}function ie(e,t,n){return function(...r){const s=this.__v_raw,o=u(s),i=N(o),c=e==="entries"||e===Symbol.iterator&&i,f=e==="keys"&&i,l=s[e](...r),h=n?Re:t?je:Ce;return!t&&m(o,"iterate",f?Oe:A),{next(){const{value:d,done:v}=l.next();return v?{value:d,done:v}:{value:c?[h(d[0]),h(d[1])]:h(d),done:v}},[Symbol.iterator](){return this}}}}function R(e){return function(...t){{const n=t[0]?`on key "${t[0]}" `:"";console.warn(`${Kt(e)} operation ${n}failed: target is readonly.`,u(this))}return e==="delete"?!1:e==="clear"?void 0:this}}function tn(){const e={get(o){return ne(this,o)},get size(){return se(this)},has:re,add:st,set:ot,delete:it,clear:ct,forEach:oe(!1,!1)},t={get(o){return ne(this,o,!1,!0)},get size(){return se(this)},has:re,add:st,set:ot,delete:it,clear:ct,forEach:oe(!1,!0)},n={get(o){return ne(this,o,!0)},get size(){return se(this,!0)},has(o){return re.call(this,o,!0)},add:R("add"),set:R("set"),delete:R("delete"),clear:R("clear"),forEach:oe(!0,!1)},r={get(o){return ne(this,o,!0,!0)},get size(){return se(this,!0)},has(o){return re.call(this,o,!0)},add:R("add"),set:R("set"),delete:R("delete"),clear:R("clear"),forEach:oe(!0,!0)};return["keys","values","entries",Symbol.iterator].forEach(o=>{e[o]=ie(o,!1,!1),n[o]=ie(o,!0,!1),t[o]=ie(o,!1,!0),r[o]=ie(o,!0,!0)}),[e,n,t,r]}const[nn,rn,sn,on]=tn();function ye(e,t){const n=t?e?on:sn:e?rn:nn;return(r,s,o)=>s==="__v_isReactive"?!e:s==="__v_isReadonly"?e:s==="__v_raw"?r:Reflect.get(p(n,s)&&s in r?n:r,s,o)}const cn={get:ye(!1,!1)},ln={get:ye(!0,!1)},an={get:ye(!0,!0)};function lt(e,t,n){const r=u(n);if(r!==n&&t.call(e,r)){const s=Ge(e);console.warn(`Reactive ${s} contains both the raw and reactive versions of the same object${s==="Map"?" as keys":""}, which can lead to inconsistencies. Avoid differentiating between the raw and reactive versions of an object and only use the reactive version if possible.`)}}const at=new WeakMap,un=new WeakMap,ut=new WeakMap,ft=new WeakMap;function fn(e){switch(e){case"Object":case"Array":return 1;case"Map":case"Set":case"WeakMap":case"WeakSet":return 2;default:return 0}}function dn(e){return e.__v_skip||!Object.isExtensible(e)?0:fn(Ge(e))}function Te(e){return le(e)?e:Me(e,!1,Zt,cn,at)}function dt(e){return Me(e,!0,kt,ln,ut)}function ce(e){return Me(e,!0,en,an,ft)}function Me(e,t,n,r,s){if(!C(e))return console.warn(`value cannot be made reactive: ${String(e)}`),e;if(e.__v_raw&&!(t&&e.__v_isReactive))return e;const o=s.get(e);if(o)return o;const i=dn(e);if(i===0)return e;const c=new Proxy(e,i===2?r:n);return s.set(e,c),c}function G(e){return le(e)?G(e.__v_raw):!!(e&&e.__v_isReactive)}function le(e){return!!(e&&e.__v_isReadonly)}function $e(e){return!!(e&&e.__v_isShallow)}function u(e){const t=e&&e.__v_raw;return t?u(t):e}function pn(e){return Nt(e,"__v_skip",!0),e}const Ce=e=>C(e)?Te(e):e,je=e=>C(e)?dt(e):e;function x(e){return!!(e&&e.__v_isRef===!0)}function hn(e){return x(e)?e.value:e}const gn={get:(e,t,n)=>hn(Reflect.get(e,t,n)),set:(e,t,n,r)=>{const s=e[t];return x(s)&&!x(n)?(s.value=n,!0):Reflect.set(e,t,n,r)}};function _n(e){return G(e)?e:new Proxy(e,gn)}var wn={NODE_ENV:'"production"'};const H=[];function bn(e){H.push(e)}function mn(){H.pop()}function _(e,...t){Se();const n=H.length?H[H.length-1].component:null,r=n&&n.appContext.config.warnHandler,s=Sn();if(r)L(r,n,11,[e+t.join(""),n&&n.proxy,s.map(({vnode:o})=>`at <${Mt(n,o.type)}>`).join(`
`),s]);else{const o=[`[Vue warn]: ${e}`,...t];s.length&&o.push(`
`,...vn(s)),console.warn(...o)}ve()}function Sn(){let e=H[H.length-1];if(!e)return[];const t=[];for(;e;){const n=t[0];n&&n.vnode===e?n.recurseCount++:t.push({vnode:e,recurseCount:0});const r=e.component&&e.component.parent;e=r&&r.vnode}return t}function vn(e){const t=[];return e.forEach((n,r)=>{t.push(...r===0?[]:[`
`],...En(n))}),t}function En({vnode:e,recurseCount:t}){const n=t>0?`... (${t} recursive calls)`:"",r=e.component?e.component.parent==null:!1,s=` at <${Mt(e.component,e.type,r)}`,o=">"+n;return e.props?[s,...xn(e.props),o]:[s+o]}function xn(e){const t=[],n=Object.keys(e);return n.slice(0,3).forEach(r=>{t.push(...pt(r,e[r]))}),n.length>3&&t.push(" ..."),t}function pt(e,t,n){return we(t)?(t=JSON.stringify(t),n?t:[`${e}=${t}`]):typeof t=="number"||typeof t=="boolean"||t==null?n?t:[`${e}=${t}`]:x(t)?(t=pt(e,u(t.value),!0),n?t:[`${e}=Ref<`,t,">"]):b(t)?[`${e}=fn${t.name?`<${t.name}>`:""}`]:(t=u(t),n?t:[`${e}=`,t])}const ht={sp:"serverPrefetch hook",bc:"beforeCreate hook",c:"created hook",bm:"beforeMount hook",m:"mounted hook",bu:"beforeUpdate hook",u:"updated",bum:"beforeUnmount hook",um:"unmounted hook",a:"activated hook",da:"deactivated hook",ec:"errorCaptured hook",rtc:"renderTracked hook",rtg:"renderTriggered hook",0:"setup function",1:"render function",2:"watcher getter",3:"watcher callback",4:"watcher cleanup function",5:"native event handler",6:"component event handler",7:"vnode hook",8:"directive hook",9:"transition hook",10:"app errorHandler",11:"app warnHandler",12:"ref function",13:"async component loader",14:"scheduler flush. This is likely a Vue internals bug. Please open an issue at https://github.com/vuejs/core ."};function L(e,t,n,r){let s;try{s=r?e(...r):e()}catch(o){Ae(o,t,n)}return s}function ae(e,t,n,r){if(b(e)){const o=L(e,t,n,r);return o&&Ht(o)&&o.catch(i=>{Ae(i,t,n)}),o}const s=[];for(let o=0;o<e.length;o++)s.push(ae(e[o],t,n,r));return s}function Ae(e,t,n,r=!0){const s=t?t.vnode:null;if(t){let o=t.parent;const i=t.proxy,c=ht[n];for(;o;){const l=o.ec;if(l){for(let h=0;h<l.length;h++)if(l[h](e,i,c)===!1)return}o=o.parent}const f=t.appContext.config.errorHandler;if(f){L(f,null,10,[e,i,c]);return}}In(e,n,s,r)}function In(e,t,n,r=!0){{const s=ht[t];if(n&&bn(n),_(`Unhandled error${s?` during execution of ${s}`:""}`),n&&mn(),r)throw e;console.error(e)}}let ue=!1,He=!1;const E=[];let y=0;const F=[];let I=null,T=0;const gt=Promise.resolve();let Le=null;const Pn=100;function On(e){const t=Le||gt;return e?t.then(this?e.bind(this):e):t}function Rn(e){let t=y+1,n=E.length;for(;t<n;){const r=t+n>>>1,s=E[r],o=J(s);o<e||o===e&&s.pre?t=r+1:n=r}return t}function Ve(e){(!E.length||!E.includes(e,ue&&e.allowRecurse?y+1:y))&&(e.id==null?E.push(e):E.splice(Rn(e.id),0,e),_t())}function _t(){!ue&&!He&&(He=!0,Le=gt.then(bt))}function wt(e){g(e)?F.push(...e):(!I||!I.includes(e,e.allowRecurse?T+1:T))&&F.push(e),_t()}function yn(e){if(F.length){const t=[...new Set(F)].sort((n,r)=>J(n)-J(r));if(F.length=0,I){I.push(...t);return}for(I=t,e=e||new Map,T=0;T<I.length;T++)mt(e,I[T])||I[T]();I=null,T=0}}const J=e=>e.id==null?1/0:e.id,Tn=(e,t)=>{const n=J(e)-J(t);if(n===0){if(e.pre&&!t.pre)return-1;if(t.pre&&!e.pre)return 1}return n};function bt(e){He=!1,ue=!0,e=e||new Map,E.sort(Tn);const t=n=>mt(e,n);try{for(y=0;y<E.length;y++){const n=E[y];if(n&&n.active!==!1){if(wn.NODE_ENV!=="production"&&t(n))continue;L(n,null,14)}}}finally{y=0,E.length=0,yn(e),ue=!1,Le=null,(E.length||F.length)&&bt(e)}}function mt(e,t){if(!e.has(t))e.set(t,1);else{const n=e.get(t);if(n>Pn){const r=t.ownerInstance,s=r&&Tt(r.type);return Ae(`Maximum recursive updates exceeded${s?` in component <${s}>`:""}. This means you have a reactive effect that is mutating its own dependencies and thus recursively triggering itself. Possible sources include component template, render function, updated hook or watcher source function.`,null,10),!0}else e.set(t,n+1)}}const B=new Set;Be().__VUE_HMR_RUNTIME__={createRecord:Ke(Mn),rerender:Ke($n),reload:Ke(Cn)};const fe=new Map;function Mn(e,t){return fe.has(e)?!1:(fe.set(e,{initialDef:Y(t),instances:new Set}),!0)}function Y(e){return Zn(e)?e.__vccOpts:e}function $n(e,t){const n=fe.get(e);n&&(n.initialDef.render=t,[...n.instances].forEach(r=>{t&&(r.render=t,Y(r.type).render=t),r.renderCache=[],r.effect.dirty=!0,r.update()}))}function Cn(e,t){const n=fe.get(e);if(!n)return;t=Y(t),St(n.initialDef,t);const r=[...n.instances];for(const s of r){const o=Y(s.type);B.has(o)||(o!==n.initialDef&&St(o,t),B.add(o)),s.appContext.propsCache.delete(s.type),s.appContext.emitsCache.delete(s.type),s.appContext.optionsCache.delete(s.type),s.ceReload?(B.add(o),s.ceReload(t.styles),B.delete(o)):s.parent?(s.parent.effect.dirty=!0,Ve(s.parent.update)):s.appContext.reload?s.appContext.reload():typeof window<"u"?window.location.reload():console.warn("[HMR] Root or manually mounted instance modified. Full reload required.")}wt(()=>{for(const s of r)B.delete(Y(s.type))})}function St(e,t){P(e,t);for(const n in e)n!=="__file"&&!(n in t)&&delete e[n]}function Ke(e){return(t,n)=>{try{return e(t,n)}catch(r){console.error(r),console.warn("[HMR] Something went wrong during Vue component hot-reload. Full reload required.")}}}let jn=null;function An(e,t){t&&t.pendingBranch?g(e)?t.effects.push(...e):t.effects.push(e):wt(e)}const Hn=Symbol.for("v-scx"),Ln=()=>{{const e=Gn(Hn);return e||_("Server rendering context not provided. Make sure to only call useSSRContext() conditionally in the server build."),e}},de={};function Vn(e,t,n){return b(t)||_("`watch(fn, options?)` signature has been moved to a separate API. Use `watchEffect(fn, options?)` instead. `watch` now only supports `watch(source, cb, options?) signature."),vt(e,t,n)}function vt(e,t,{immediate:n,deep:r,flush:s,once:o,onTrack:i,onTrigger:c}=$){if(t&&o){const a=t;t=(...qe)=>{a(...qe),De()}}r!==void 0&&typeof r=="number"&&_('watch() "deep" option with number value will be used as watch depth in future versions. Please use a boolean instead to avoid potential breakage.'),t||(n!==void 0&&_('watch() "immediate" option is only respected when using the watch(source, callback, options?) signature.'),r!==void 0&&_('watch() "deep" option is only respected when using the watch(source, callback, options?) signature.'),o!==void 0&&_('watch() "once" option is only respected when using the watch(source, callback, options?) signature.'));const f=a=>{_("Invalid watch source: ",a,"A watch source can only be a getter/effect function, a ref, a reactive object, or an array of these types.")},l=he,h=a=>r===!0?a:W(a,r===!1?1:void 0);let d,v=!1,M=!1;if(x(e)?(d=()=>e.value,v=$e(e)):G(e)?(d=()=>h(e),v=!0):g(e)?(M=!0,v=e.some(a=>G(a)||$e(a)),d=()=>e.map(a=>{if(x(a))return a.value;if(G(a))return h(a);if(b(a))return L(a,l,2);f(a)})):b(e)?t?d=()=>L(e,l,2):d=()=>(z&&z(),ae(e,l,3,[ge])):(d=D,f(e)),t&&r){const a=d;d=()=>W(a())}let z,ge=a=>{z=S.onStop=()=>{L(a,l,4),z=S.onStop=void 0}},ze;if(yt)if(ge=D,t?n&&ae(t,l,3,[d(),M?[]:void 0,ge]):d(),s==="sync"){const a=Ln();ze=a.__watcherHandles||(a.__watcherHandles=[])}else return D;let V=M?new Array(e.length).fill(de):de;const K=()=>{if(!(!S.active||!S.dirty))if(t){const a=S.run();(r||v||(M?a.some((qe,er)=>U(qe,V[er])):U(a,V)))&&(z&&z(),ae(t,l,3,[a,V===de?void 0:M&&V[0]===de?[]:V,ge]),V=a)}else S.run()};K.allowRecurse=!!t;let _e;s==="sync"?_e=K:s==="post"?_e=()=>Rt(K,l&&l.suspense):(K.pre=!0,l&&(K.id=l.uid),_e=()=>Ve(K));const S=new Wt(d,D,_e),De=()=>{S.stop()};return S.onTrack=i,S.onTrigger=c,t?n?K():V=S.run():s==="post"?Rt(S.run.bind(S),l&&l.suspense):S.run(),ze&&ze.push(De),De}function Kn(e,t,n){const r=this.proxy,s=we(e)?e.includes(".")?Nn(r,e):()=>r[e]:e.bind(r,r);let o;b(t)?o=t:(o=t.handler,n=t);const i=Jn(this),c=vt(s,o.bind(r),n);return i(),c}function Nn(e,t){const n=t.split(".");return()=>{let r=e;for(let s=0;s<n.length&&r;s++)r=r[n[s]];return r}}function W(e,t,n=0,r){if(!C(e)||e.__v_skip)return e;if(t&&t>0){if(n>=t)return e;n++}if(r=r||new Set,r.has(e))return e;if(r.add(e),x(e))W(e.value,t,n,r);else if(g(e))for(let s=0;s<e.length;s++)W(e[s],t,n,r);else if(At(e)||N(e))e.forEach(s=>{W(s,t,n,r)});else if(Vt(e))for(const s in e)W(e[s],t,n,r);return e}const Ne=e=>e?Bn(e)?Yn(e)||e.proxy:Ne(e.parent):null,Q=P(Object.create(null),{$:e=>e,$el:e=>e.vnode.el,$data:e=>e.data,$props:e=>ce(e.props),$attrs:e=>ce(e.attrs),$slots:e=>ce(e.slots),$refs:e=>ce(e.refs),$parent:e=>Ne(e.parent),$root:e=>Ne(e.root),$emit:e=>e.emit,$options:e=>__VUE_OPTIONS_API__?Wn(e):e.type,$forceUpdate:e=>e.f||(e.f=()=>{e.effect.dirty=!0,Ve(e.update)}),$nextTick:e=>e.n||(e.n=On.bind(e.proxy)),$watch:e=>__VUE_OPTIONS_API__?Kn.bind(e):D}),Ue=(e,t)=>e!==$&&!e.__isScriptSetup&&p(e,t),Un={get({_:e},t){const{ctx:n,setupState:r,data:s,props:o,accessCache:i,type:c,appContext:f}=e;if(t==="__isVue")return!0;let l;if(t[0]!=="$"){const M=i[t];if(M!==void 0)switch(M){case 1:return r[t];case 2:return s[t];case 4:return n[t];case 3:return o[t]}else{if(Ue(r,t))return i[t]=1,r[t];if(s!==$&&p(s,t))return i[t]=2,s[t];if((l=e.propsOptions[0])&&p(l,t))return i[t]=3,o[t];if(n!==$&&p(n,t))return i[t]=4,n[t];(!__VUE_OPTIONS_API__||Fn)&&(i[t]=0)}}const h=Q[t];let d,v;if(h)return(t==="$attrs"||t==="$slots")&&m(e,"get",t),h(e);if((d=c.__cssModules)&&(d=d[t]))return d;if(n!==$&&p(n,t))return i[t]=4,n[t];if(v=f.config.globalProperties,p(v,t))return v[t]},set({_:e},t,n){const{data:r,setupState:s,ctx:o}=e;return Ue(s,t)?(s[t]=n,!0):s.__isScriptSetup&&p(s,t)?(_(`Cannot mutate <script setup> binding "${t}" from Options API.`),!1):r!==$&&p(r,t)?(r[t]=n,!0):p(e.props,t)?(_(`Attempting to mutate prop "${t}". Props are readonly.`),!1):t[0]==="$"&&t.slice(1)in e?(_(`Attempting to mutate public property "${t}". Properties starting with $ are reserved and readonly.`),!1):(t in e.appContext.config.globalProperties?Object.defineProperty(o,t,{enumerable:!0,configurable:!0,value:n}):o[t]=n,!0)},has({_:{data:e,setupState:t,accessCache:n,ctx:r,appContext:s,propsOptions:o}},i){let c;return!!n[i]||e!==$&&p(e,i)||Ue(t,i)||(c=o[0])&&p(c,i)||p(r,i)||p(Q,i)||p(s.config.globalProperties,i)},defineProperty(e,t,n){return n.get!=null?e._.accessCache[t]=0:p(n,"value")&&this.set(e,t,n.value,null),Reflect.defineProperty(e,t,n)}};Un.ownKeys=e=>(_("Avoid app logic that relies on enumerating keys on a component instance. The keys will be empty in production mode to avoid performance overhead."),Reflect.ownKeys(e));function Et(e){return g(e)?e.reduce((t,n)=>(t[n]=null,t),{}):e}let Fn=!0;function Wn(e){const t=e.type,{mixins:n,extends:r}=t,{mixins:s,optionsCache:o,config:{optionMergeStrategies:i}}=e.appContext,c=o.get(t);let f;return c?f=c:!s.length&&!n&&!r?f=t:(f={},s.length&&s.forEach(l=>pe(f,l,i,!0)),pe(f,t,i)),C(t)&&o.set(t,f),f}function pe(e,t,n,r=!1){const{mixins:s,extends:o}=t;o&&pe(e,o,n,!0),s&&s.forEach(i=>pe(e,i,n,!0));for(const i in t)if(r&&i==="expose")_('"expose" option is ignored when declared in mixins or extends. It should only be declared in the base component itself.');else{const c=zn[i]||n&&n[i];e[i]=c?c(e[i],t[i]):t[i]}return e}const zn={data:xt,props:Pt,emits:Pt,methods:X,computed:X,beforeCreate:w,created:w,beforeMount:w,mounted:w,beforeUpdate:w,updated:w,beforeDestroy:w,beforeUnmount:w,destroyed:w,unmounted:w,activated:w,deactivated:w,errorCaptured:w,serverPrefetch:w,components:X,directives:X,watch:qn,provide:xt,inject:Dn};function xt(e,t){return t?e?function(){return P(b(e)?e.call(this,this):e,b(t)?t.call(this,this):t)}:t:e}function Dn(e,t){return X(It(e),It(t))}function It(e){if(g(e)){const t={};for(let n=0;n<e.length;n++)t[e[n]]=e[n];return t}return e}function w(e,t){return e?[...new Set([].concat(e,t))]:t}function X(e,t){return e?P(Object.create(null),e,t):t}function Pt(e,t){return e?g(e)&&g(t)?[...new Set([...e,...t])]:P(Object.create(null),Et(e),Et(t??{})):t}function qn(e,t){if(!e)return t;if(!t)return e;const n=P(Object.create(null),e);for(const r in t)n[r]=w(e[r],t[r]);return n}let Ot=null;function Gn(e,t,n=!1){const r=he||jn;if(r||Ot){const s=r?r.parent==null?r.vnode.appContext&&r.vnode.appContext.provides:r.parent.provides:Ot._context.provides;if(s&&e in s)return s[e];if(arguments.length>1)return n&&b(t)?t.call(r&&r.proxy):t;_(`injection "${String(e)}" not found.`)}else _("inject() can only be used inside setup() or functional components.")}const Rt=An;let he=null,Fe;{const e=Be(),t=(n,r)=>{let s;return(s=e[n])||(s=e[n]=[]),s.push(r),o=>{s.length>1?s.forEach(i=>i(o)):s[0](o)}};Fe=t("__VUE_INSTANCE_SETTERS__",n=>he=n),t("__VUE_SSR_SETTERS__",n=>yt=n)}const Jn=e=>{const t=he;return Fe(e),e.scope.on(),()=>{e.scope.off(),Fe(t)}};function Bn(e){return e.vnode.shapeFlag&4}let yt=!1;function Yn(e){if(e.exposed)return e.exposeProxy||(e.exposeProxy=new Proxy(_n(pn(e.exposed)),{get(t,n){if(n in t)return t[n];if(n in Q)return Q[n](e)},has(t,n){return n in t||n in Q}}))}const Qn=/(?:^|[-_])(\w)/g,Xn=e=>e.replace(Qn,t=>t.toUpperCase()).replace(/[-_]/g,"");function Tt(e,t=!0){return b(e)?e.displayName||e.name:e.name||t&&e.__name}function Mt(e,t,n=!1){let r=Tt(t);if(!r&&t.__file){const s=t.__file.match(/([^/\\]+)\.\w+$/);s&&(r=s[1])}if(!r&&e&&e.parent){const s=o=>{for(const i in o)if(o[i]===t)return i};r=s(e.components||e.parent.type.components)||s(e.appContext.components)}return r?Xn(r):n?"App":"Anonymous"}function Zn(e){return b(e)&&"__vccOpts"in e}const We=new WeakMap;function kn(e){return e instanceof HTMLElement}function $t(e,t,n){var i;let r=e;if(!kn(e)&&typeof e=="string"&&(e=document.querySelector(e)),!!e){if(Object.prototype.toString.call(e).slice(8,-1)==="Array")return e.map(c=>{$t(c,t,n)});try{(i=We.get(e))==null||i.disconnect(),We.delete(e)}catch{}var s=new MutationObserver(function(c,f){for(let l of c)if(l.type==="attributes"&&l.attributeName===t){e.classList,n(e,r);break}}),o={attributes:!0,childList:!1,subtree:!1};return s.observe(e,o),We.set(s),s}}typeof globalThis.postToNative>"u"&&async function(){const e=function(...s){var o,i,c;(c=(i=(o=window.webkit)==null?void 0:o.messageHandlers)==null?void 0:i.logHandler)==null||c.postMessage(s.join(" "))},t=window.webkit?function(s){var o,i,c;(c=(i=(o=window.webkit)==null?void 0:o.messageHandlers)==null?void 0:i.native)==null||c.postMessage(s)}:function(s){console.log("%c postToNative %o","background: #222; color: #bada55",s)},n=function(s,o){globalThis.hasOwnProperty(s)||Object.defineProperty(globalThis,s,{value:o,writable:!1})};let r=Te({});Vn(()=>r,function(s){var o,i,c;(c=(i=(o=window.webkit)==null?void 0:o.messageHandlers)==null?void 0:i.webViewBridge)==null||c.postMessage(u(s))},{deep:!0}),n("bridge",r),n("postToNative",t),n("observe",$t),window.webkit&&(window.console.log=e,window.console.warn=e,window.console.error=e,window.onerror=e)}()});
