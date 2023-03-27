(function(Z){typeof define=="function"&&define.amd?define(Z):Z()})(function(){"use strict";function Z(e,t){const n=Object.create(null),o=e.split(",");for(let r=0;r<o.length;r++)n[o[r]]=!0;return t?r=>!!n[r.toLowerCase()]:r=>!!n[r]}Object.freeze({}),Object.freeze([]);const Fe=Object.assign,jt=Object.prototype.hasOwnProperty,k=(e,t)=>jt.call(e,t),$=Array.isArray,G=e=>Ue(e)==="[object Map]",yt=e=>typeof e=="string",we=e=>typeof e=="symbol",ee=e=>e!==null&&typeof e=="object",vt=Object.prototype.toString,Ue=e=>vt.call(e),We=e=>Ue(e).slice(8,-1),_e=e=>yt(e)&&e!=="NaN"&&e[0]!=="-"&&""+parseInt(e,10)===e,At=(e=>{const t=Object.create(null);return n=>t[n]||(t[n]=e(n))})(e=>e.charAt(0).toUpperCase()+e.slice(1)),ze=(e,t)=>!Object.is(e,t),Ht=(e,t,n)=>{Object.defineProperty(e,t,{configurable:!0,enumerable:!1,value:n})};function Ve(e,...t){console.warn(`[Vue warn] ${e}`,...t)}let De;function Nt(e,t=De){t&&t.active&&t.effects.push(e)}function Kt(){return De}const Ge=e=>{const t=new Set(e);return t.w=0,t.n=0,t},qe=e=>(e.w&M)>0,Be=e=>(e.n&M)>0,Ft=({deps:e})=>{if(e.length)for(let t=0;t<e.length;t++)e[t].w|=M},Ut=e=>{const{deps:t}=e;if(t.length){let n=0;for(let o=0;o<t.length;o++){const r=t[o];qe(r)&&!Be(r)?r.delete(e):t[n++]=r,r.w&=~M,r.n&=~M}t.length=n}},me=new WeakMap;let q=0,M=1;const be=30;let w;const y=Symbol("iterate"),Se=Symbol("Map key iterate");class Wt{constructor(t,n=null,o){this.fn=t,this.scheduler=n,this.active=!0,this.deps=[],this.parent=void 0,Nt(this,o)}run(){if(!this.active)return this.fn();let t=w,n=v;for(;t;){if(t===this)return;t=t.parent}try{return this.parent=w,w=this,v=!0,M=1<<++q,q<=be?Ft(this):Je(this),this.fn()}finally{q<=be&&Ut(this),M=1<<--q,w=this.parent,v=n,this.parent=void 0,this.deferStop&&this.stop()}}stop(){w===this?this.deferStop=!0:this.active&&(Je(this),this.onStop&&this.onStop(),this.active=!1)}}function Je(e){const{deps:t}=e;if(t.length){for(let n=0;n<t.length;n++)t[n].delete(e);t.length=0}}let v=!0;const Le=[];function Ye(){Le.push(v),v=!1}function Qe(){const e=Le.pop();v=e===void 0?!0:e}function m(e,t,n){if(v&&w){let o=me.get(e);o||me.set(e,o=new Map);let r=o.get(n);r||o.set(n,r=Ge()),zt(r,{effect:w,target:e,type:t,key:n})}}function zt(e,t){let n=!1;q<=be?Be(e)||(e.n|=M,n=!qe(e)):n=!e.has(w),n&&(e.add(w),w.deps.push(e),w.onTrack&&w.onTrack(Object.assign({effect:w},t)))}function E(e,t,n,o,r,s){const i=me.get(e);if(!i)return;let c=[];if(t==="clear")c=[...i.values()];else if(n==="length"&&$(e)){const l=Number(o);i.forEach((p,d)=>{(d==="length"||d>=l)&&c.push(p)})}else switch(n!==void 0&&c.push(i.get(n)),t){case"add":$(e)?_e(n)&&c.push(i.get("length")):(c.push(i.get(y)),G(e)&&c.push(i.get(Se)));break;case"delete":$(e)||(c.push(i.get(y)),G(e)&&c.push(i.get(Se)));break;case"set":G(e)&&c.push(i.get(y));break}const a={target:e,type:t,key:n,newValue:o,oldValue:r,oldTarget:s};if(c.length===1)c[0]&&Xe(c[0],a);else{const l=[];for(const p of c)p&&l.push(...p);Xe(Ge(l),a)}}function Xe(e,t){const n=$(e)?e:[...e];for(const o of n)o.computed&&Ze(o,t);for(const o of n)o.computed||Ze(o,t)}function Ze(e,t){(e!==w||e.allowRecurse)&&(e.onTrigger&&e.onTrigger(Fe({effect:e},t)),e.scheduler?e.scheduler():e.run())}const Vt=Z("__proto__,__v_isRef,__isVue"),ke=new Set(Object.getOwnPropertyNames(Symbol).filter(e=>e!=="arguments"&&e!=="caller").map(e=>Symbol[e]).filter(we)),Dt=Oe(),Gt=Oe(!0),qt=Oe(!0,!0),et=Bt();function Bt(){const e={};return["includes","indexOf","lastIndexOf"].forEach(t=>{e[t]=function(...n){const o=f(this);for(let s=0,i=this.length;s<i;s++)m(o,"get",s+"");const r=o[t](...n);return r===-1||r===!1?o[t](...n.map(f)):r}}),["push","pop","shift","unshift","splice"].forEach(t=>{e[t]=function(...n){Ye();const o=f(this)[t].apply(this,n);return Qe(),o}}),e}function Jt(e){const t=f(this);return m(t,"has",e),t.hasOwnProperty(e)}function Oe(e=!1,t=!1){return function(o,r,s){if(r==="__v_isReactive")return!e;if(r==="__v_isReadonly")return e;if(r==="__v_isShallow")return t;if(r==="__v_raw"&&s===(e?t?lt:at:t?fn:ct).get(o))return o;const i=$(o);if(!e){if(i&&k(et,r))return Reflect.get(et,r,s);if(r==="hasOwnProperty")return Jt}const c=Reflect.get(o,r,s);return(we(r)?ke.has(r):Vt(r))||(e||m(o,"get",r),t)?c:O(c)?i&&_e(r)?c:c.value:ee(c)?e?ft(c):Te(c):c}}const Lt=Yt();function Yt(e=!1){return function(n,o,r,s){let i=n[o];if(ae(i)&&O(i)&&!O(r))return!1;if(!e&&(!$e(r)&&!ae(r)&&(i=f(i),r=f(r)),!$(n)&&O(i)&&!O(r)))return i.value=r,!0;const c=$(n)&&_e(o)?Number(o)<n.length:k(n,o),a=Reflect.set(n,o,r,s);return n===f(s)&&(c?ze(r,i)&&E(n,"set",o,r,i):E(n,"add",o,r)),a}}function Qt(e,t){const n=k(e,t),o=e[t],r=Reflect.deleteProperty(e,t);return r&&n&&E(e,"delete",t,void 0,o),r}function Xt(e,t){const n=Reflect.has(e,t);return(!we(t)||!ke.has(t))&&m(e,"has",t),n}function Zt(e){return m(e,"iterate",$(e)?"length":y),Reflect.ownKeys(e)}const kt={get:Dt,set:Lt,deleteProperty:Qt,has:Xt,ownKeys:Zt},tt={get:Gt,set(e,t){return Ve(`Set operation on key "${String(t)}" failed: target is readonly.`,e),!0},deleteProperty(e,t){return Ve(`Delete operation on key "${String(t)}" failed: target is readonly.`,e),!0}},en=Fe({},tt,{get:qt}),xe=e=>e,te=e=>Reflect.getPrototypeOf(e);function ne(e,t,n=!1,o=!1){e=e.__v_raw;const r=f(e),s=f(t);n||(t!==s&&m(r,"get",t),m(r,"get",s));const{has:i}=te(r),c=o?xe:n?Ee:Me;if(i.call(r,t))return c(e.get(t));if(i.call(r,s))return c(e.get(s));e!==r&&e.get(t)}function re(e,t=!1){const n=this.__v_raw,o=f(n),r=f(e);return t||(e!==r&&m(o,"has",e),m(o,"has",r)),e===r?n.has(e):n.has(e)||n.has(r)}function oe(e,t=!1){return e=e.__v_raw,!t&&m(f(e),"iterate",y),Reflect.get(e,"size",e)}function nt(e){e=f(e);const t=f(this);return te(t).has.call(t,e)||(t.add(e),E(t,"add",e,e)),this}function rt(e,t){t=f(t);const n=f(this),{has:o,get:r}=te(n);let s=o.call(n,e);s?it(n,o,e):(e=f(e),s=o.call(n,e));const i=r.call(n,e);return n.set(e,t),s?ze(t,i)&&E(n,"set",e,t,i):E(n,"add",e,t),this}function ot(e){const t=f(this),{has:n,get:o}=te(t);let r=n.call(t,e);r?it(t,n,e):(e=f(e),r=n.call(t,e));const s=o?o.call(t,e):void 0,i=t.delete(e);return r&&E(t,"delete",e,void 0,s),i}function st(){const e=f(this),t=e.size!==0,n=G(e)?new Map(e):new Set(e),o=e.clear();return t&&E(e,"clear",void 0,void 0,n),o}function se(e,t){return function(o,r){const s=this,i=s.__v_raw,c=f(i),a=t?xe:e?Ee:Me;return!e&&m(c,"iterate",y),i.forEach((l,p)=>o.call(r,a(l),a(p),s))}}function ie(e,t,n){return function(...o){const r=this.__v_raw,s=f(r),i=G(s),c=e==="entries"||e===Symbol.iterator&&i,a=e==="keys"&&i,l=r[e](...o),p=n?xe:t?Ee:Me;return!t&&m(s,"iterate",a?Se:y),{next(){const{value:d,done:S}=l.next();return S?{value:d,done:S}:{value:c?[p(d[0]),p(d[1])]:p(d),done:S}},[Symbol.iterator](){return this}}}}function R(e){return function(...t){{const n=t[0]?`on key "${t[0]}" `:"";console.warn(`${At(e)} operation ${n}failed: target is readonly.`,f(this))}return e==="delete"?!1:this}}function tn(){const e={get(s){return ne(this,s)},get size(){return oe(this)},has:re,add:nt,set:rt,delete:ot,clear:st,forEach:se(!1,!1)},t={get(s){return ne(this,s,!1,!0)},get size(){return oe(this)},has:re,add:nt,set:rt,delete:ot,clear:st,forEach:se(!1,!0)},n={get(s){return ne(this,s,!0)},get size(){return oe(this,!0)},has(s){return re.call(this,s,!0)},add:R("add"),set:R("set"),delete:R("delete"),clear:R("clear"),forEach:se(!0,!1)},o={get(s){return ne(this,s,!0,!0)},get size(){return oe(this,!0)},has(s){return re.call(this,s,!0)},add:R("add"),set:R("set"),delete:R("delete"),clear:R("clear"),forEach:se(!0,!0)};return["keys","values","entries",Symbol.iterator].forEach(s=>{e[s]=ie(s,!1,!1),n[s]=ie(s,!0,!1),t[s]=ie(s,!1,!0),o[s]=ie(s,!0,!0)}),[e,n,t,o]}const[nn,rn,on,sn]=tn();function Pe(e,t){const n=t?e?sn:on:e?rn:nn;return(o,r,s)=>r==="__v_isReactive"?!e:r==="__v_isReadonly"?e:r==="__v_raw"?o:Reflect.get(k(n,r)&&r in o?n:o,r,s)}const cn={get:Pe(!1,!1)},an={get:Pe(!0,!1)},ln={get:Pe(!0,!0)};function it(e,t,n){const o=f(n);if(o!==n&&t.call(e,o)){const r=We(e);console.warn(`Reactive ${r} contains both the raw and reactive versions of the same object${r==="Map"?" as keys":""}, which can lead to inconsistencies. Avoid differentiating between the raw and reactive versions of an object and only use the reactive version if possible.`)}}const ct=new WeakMap,fn=new WeakMap,at=new WeakMap,lt=new WeakMap;function un(e){switch(e){case"Object":case"Array":return 1;case"Map":case"Set":case"WeakMap":case"WeakSet":return 2;default:return 0}}function pn(e){return e.__v_skip||!Object.isExtensible(e)?0:un(We(e))}function Te(e){return ae(e)?e:Ie(e,!1,kt,cn,ct)}function ft(e){return Ie(e,!0,tt,an,at)}function ce(e){return Ie(e,!0,en,ln,lt)}function Ie(e,t,n,o,r){if(!ee(e))return console.warn(`value cannot be made reactive: ${String(e)}`),e;if(e.__v_raw&&!(t&&e.__v_isReactive))return e;const s=r.get(e);if(s)return s;const i=pn(e);if(i===0)return e;const c=new Proxy(e,i===2?o:n);return r.set(e,c),c}function B(e){return ae(e)?B(e.__v_raw):!!(e&&e.__v_isReactive)}function ae(e){return!!(e&&e.__v_isReadonly)}function $e(e){return!!(e&&e.__v_isShallow)}function f(e){const t=e&&e.__v_raw;return t?f(t):e}function dn(e){return Ht(e,"__v_skip",!0),e}const Me=e=>ee(e)?Te(e):e,Ee=e=>ee(e)?ft(e):e;function O(e){return!!(e&&e.__v_isRef===!0)}function hn(e){return O(e)?e.value:e}const gn={get:(e,t,n)=>hn(Reflect.get(e,t,n)),set:(e,t,n,o)=>{const r=e[t];return O(r)&&!O(n)?(r.value=n,!0):Reflect.set(e,t,n,o)}};function wn(e){return B(e)?e:new Proxy(e,gn)}const A=Object.freeze({});Object.freeze([]);const le=()=>{},_n=()=>!1,z=Object.assign,mn=(e,t)=>{const n=e.indexOf(t);n>-1&&e.splice(n,1)},bn=Object.prototype.hasOwnProperty,h=(e,t)=>bn.call(e,t),J=Array.isArray,Sn=e=>Ce(e)==="[object Map]",On=e=>Ce(e)==="[object Set]",b=e=>typeof e=="function",ut=e=>typeof e=="string",Re=e=>e!==null&&typeof e=="object",xn=e=>Re(e)&&b(e.then)&&b(e.catch),Pn=Object.prototype.toString,Ce=e=>Pn.call(e),Tn=e=>Ce(e)==="[object Object]",pt=(e,t)=>!Object.is(e,t);let dt;const In=()=>dt||(dt=typeof globalThis<"u"?globalThis:typeof self<"u"?self:typeof window<"u"?window:typeof global<"u"?global:{}),H=[];function $n(e){H.push(e)}function Mn(){H.pop()}function _(e,...t){Ye();const n=H.length?H[H.length-1].component:null,o=n&&n.appContext.config.warnHandler,r=En();if(o)N(o,n,11,[e+t.join(""),n&&n.proxy,r.map(({vnode:s})=>`at <${Rt(n,s.type)}>`).join(`
`),r]);else{const s=[`[Vue warn]: ${e}`,...t];r.length&&s.push(`
`,...Rn(r)),console.warn(...s)}Qe()}function En(){let e=H[H.length-1];if(!e)return[];const t=[];for(;e;){const n=t[0];n&&n.vnode===e?n.recurseCount++:t.push({vnode:e,recurseCount:0});const o=e.component&&e.component.parent;e=o&&o.vnode}return t}function Rn(e){const t=[];return e.forEach((n,o)=>{t.push(...o===0?[]:[`
`],...Cn(n))}),t}function Cn({vnode:e,recurseCount:t}){const n=t>0?`... (${t} recursive calls)`:"",o=e.component?e.component.parent==null:!1,r=` at <${Rt(e.component,e.type,o)}`,s=">"+n;return e.props?[r,...jn(e.props),s]:[r+s]}function jn(e){const t=[],n=Object.keys(e);return n.slice(0,3).forEach(o=>{t.push(...ht(o,e[o]))}),n.length>3&&t.push(" ..."),t}function ht(e,t,n){return ut(t)?(t=JSON.stringify(t),n?t:[`${e}=${t}`]):typeof t=="number"||typeof t=="boolean"||t==null?n?t:[`${e}=${t}`]:O(t)?(t=ht(e,f(t.value),!0),n?t:[`${e}=Ref<`,t,">"]):b(t)?[`${e}=fn${t.name?`<${t.name}>`:""}`]:(t=f(t),n?t:[`${e}=`,t])}const gt={sp:"serverPrefetch hook",bc:"beforeCreate hook",c:"created hook",bm:"beforeMount hook",m:"mounted hook",bu:"beforeUpdate hook",u:"updated",bum:"beforeUnmount hook",um:"unmounted hook",a:"activated hook",da:"deactivated hook",ec:"errorCaptured hook",rtc:"renderTracked hook",rtg:"renderTriggered hook",[0]:"setup function",[1]:"render function",[2]:"watcher getter",[3]:"watcher callback",[4]:"watcher cleanup function",[5]:"native event handler",[6]:"component event handler",[7]:"vnode hook",[8]:"directive hook",[9]:"transition hook",[10]:"app errorHandler",[11]:"app warnHandler",[12]:"ref function",[13]:"async component loader",[14]:"scheduler flush. This is likely a Vue internals bug. Please open an issue at https://new-issue.vuejs.org/?repo=vuejs/core"};function N(e,t,n,o){let r;try{r=o?e(...o):e()}catch(s){wt(s,t,n)}return r}function fe(e,t,n,o){if(b(e)){const s=N(e,t,n,o);return s&&xn(s)&&s.catch(i=>{wt(i,t,n)}),s}const r=[];for(let s=0;s<e.length;s++)r.push(fe(e[s],t,n,o));return r}function wt(e,t,n,o=!0){const r=t?t.vnode:null;if(t){let s=t.parent;const i=t.proxy,c=gt[n];for(;s;){const l=s.ec;if(l){for(let p=0;p<l.length;p++)if(l[p](e,i,c)===!1)return}s=s.parent}const a=t.appContext.config.errorHandler;if(a){N(a,null,10,[e,i,c]);return}}yn(e,n,r,o)}function yn(e,t,n,o=!0){{const r=gt[t];if(n&&$n(n),_(`Unhandled error${r?` during execution of ${r}`:""}`),n&&Mn(),o)throw e;console.error(e)}}let ue=!1,je=!1;const P=[];let C=0;const V=[];let T=null,j=0;const _t=Promise.resolve();let ye=null;const vn=100;function An(e){const t=ye||_t;return e?t.then(this?e.bind(this):e):t}function Hn(e){let t=C+1,n=P.length;for(;t<n;){const o=t+n>>>1;L(P[o])<e?t=o+1:n=o}return t}function ve(e){(!P.length||!P.includes(e,ue&&e.allowRecurse?C+1:C))&&(e.id==null?P.push(e):P.splice(Hn(e.id),0,e),mt())}function mt(){!ue&&!je&&(je=!0,ye=_t.then(St))}function bt(e){J(e)?V.push(...e):(!T||!T.includes(e,e.allowRecurse?j+1:j))&&V.push(e),mt()}function Nn(e){if(V.length){const t=[...new Set(V)];if(V.length=0,T){T.push(...t);return}for(T=t,e=e||new Map,T.sort((n,o)=>L(n)-L(o)),j=0;j<T.length;j++)Ot(e,T[j])||T[j]();T=null,j=0}}const L=e=>e.id==null?1/0:e.id,Kn=(e,t)=>{const n=L(e)-L(t);if(n===0){if(e.pre&&!t.pre)return-1;if(t.pre&&!e.pre)return 1}return n};function St(e){je=!1,ue=!0,e=e||new Map,P.sort(Kn);const t=n=>Ot(e,n);try{for(C=0;C<P.length;C++){const n=P[C];if(n&&n.active!==!1){if(t(n))continue;N(n,null,14)}}}finally{C=0,P.length=0,Nn(e),ue=!1,ye=null,(P.length||V.length)&&St(e)}}function Ot(e,t){if(!e.has(t))e.set(t,1);else{const n=e.get(t);if(n>vn){const o=t.ownerInstance,r=o&&Et(o.type);return _(`Maximum recursive updates exceeded${r?` in component <${r}>`:""}. This means you have a reactive effect that is mutating its own dependencies and thus recursively triggering itself. Possible sources include component template, render function, updated hook or watcher source function.`),!0}else e.set(t,n+1)}}const Y=new Set;In().__VUE_HMR_RUNTIME__={createRecord:Ae(Fn),rerender:Ae(Un),reload:Ae(Wn)};const pe=new Map;function Fn(e,t){return pe.has(e)?!1:(pe.set(e,{initialDef:Q(t),instances:new Set}),!0)}function Q(e){return ir(e)?e.__vccOpts:e}function Un(e,t){const n=pe.get(e);!n||(n.initialDef.render=t,[...n.instances].forEach(o=>{t&&(o.render=t,Q(o.type).render=t),o.renderCache=[],o.update()}))}function Wn(e,t){const n=pe.get(e);if(!n)return;t=Q(t),xt(n.initialDef,t);const o=[...n.instances];for(const r of o){const s=Q(r.type);Y.has(s)||(s!==n.initialDef&&xt(s,t),Y.add(s)),r.appContext.optionsCache.delete(r.type),r.ceReload?(Y.add(s),r.ceReload(t.styles),Y.delete(s)):r.parent?ve(r.parent.update):r.appContext.reload?r.appContext.reload():typeof window<"u"?window.location.reload():console.warn("[HMR] Root or manually mounted instance modified. Full reload required.")}bt(()=>{for(const r of o)Y.delete(Q(r.type))})}function xt(e,t){z(e,t);for(const n in e)n!=="__file"&&!(n in t)&&delete e[n]}function Ae(e){return(t,n)=>{try{return e(t,n)}catch(o){console.error(o),console.warn("[HMR] Something went wrong during Vue component hot-reload. Full reload required.")}}}let zn=null;function Vn(e,t){t&&t.pendingBranch?J(e)?t.effects.push(...e):t.effects.push(e):bt(e)}function Dn(e,t,n=!1){const o=I||zn;if(o){const r=o.parent==null?o.vnode.appContext&&o.vnode.appContext.provides:o.parent.provides;if(r&&e in r)return r[e];if(arguments.length>1)return n&&b(t)?t.call(o.proxy):t;_(`injection "${String(e)}" not found.`)}else _("inject() can only be used inside setup() or functional components.")}const de={};function Gn(e,t,n){return b(t)||_("`watch(fn, options?)` signature has been moved to a separate API. Use `watchEffect(fn, options?)` instead. `watch` now only supports `watch(source, cb, options?) signature."),Pt(e,t,n)}function Pt(e,t,{immediate:n,deep:o,flush:r,onTrack:s,onTrigger:i}=A){t||(n!==void 0&&_('watch() "immediate" option is only respected when using the watch(source, callback, options?) signature.'),o!==void 0&&_('watch() "deep" option is only respected when using the watch(source, callback, options?) signature.'));const c=u=>{_("Invalid watch source: ",u,"A watch source can only be a getter/effect function, a ref, a reactive object, or an array of these types.")},a=Kt()===(I==null?void 0:I.scope)?I:null;let l,p=!1,d=!1;if(O(e)?(l=()=>e.value,p=$e(e)):B(e)?(l=()=>e,o=!0):J(e)?(d=!0,p=e.some(u=>B(u)||$e(u)),l=()=>e.map(u=>{if(O(u))return u.value;if(B(u))return D(u);if(b(u))return N(u,a,2);c(u)})):b(e)?t?l=()=>N(e,a,2):l=()=>{if(!(a&&a.isUnmounted))return S&&S(),fe(e,a,3,[F])}:(l=le,c(e)),t&&o){const u=l;l=()=>D(u())}let S,F=u=>{S=x.onStop=()=>{N(u,a,4)}},Ke;if(nr)if(F=le,t?n&&fe(t,a,3,[l(),d?[]:void 0,F]):l(),r==="sync"){const u=ar();Ke=u.__watcherHandles||(u.__watcherHandles=[])}else return le;let U=d?new Array(e.length).fill(de):de;const W=()=>{if(!!x.active)if(t){const u=x.run();(o||p||(d?u.some((lr,fr)=>pt(lr,U[fr])):pt(u,U)))&&(S&&S(),fe(t,a,3,[u,U===de?void 0:d&&U[0]===de?[]:U,F]),U=u)}else x.run()};W.allowRecurse=!!t;let ge;r==="sync"?ge=W:r==="post"?ge=()=>$t(W,a&&a.suspense):(W.pre=!0,a&&(W.id=a.uid),ge=()=>ve(W));const x=new Wt(l,ge);x.onTrack=s,x.onTrigger=i,t?n?W():U=x.run():r==="post"?$t(x.run.bind(x),a&&a.suspense):x.run();const Ct=()=>{x.stop(),a&&a.scope&&mn(a.scope.effects,x)};return Ke&&Ke.push(Ct),Ct}function qn(e,t,n){const o=this.proxy,r=ut(e)?e.includes(".")?Bn(o,e):()=>o[e]:e.bind(o,o);let s;b(t)?s=t:(s=t.handler,n=t);const i=I;Mt(this);const c=Pt(r,s.bind(o),n);return i?Mt(i):er(),c}function Bn(e,t){const n=t.split(".");return()=>{let o=e;for(let r=0;r<n.length&&o;r++)o=o[n[r]];return o}}function D(e,t){if(!Re(e)||e.__v_skip||(t=t||new Set,t.has(e)))return e;if(t.add(e),O(e))D(e.value,t);else if(J(e))for(let n=0;n<e.length;n++)D(e[n],t);else if(On(e)||Sn(e))e.forEach(n=>{D(n,t)});else if(Tn(e))for(const n in e)D(e[n],t);return e}const He=e=>e?tr(e)?rr(e)||e.proxy:He(e.parent):null,X=z(Object.create(null),{$:e=>e,$el:e=>e.vnode.el,$data:e=>e.data,$props:e=>ce(e.props),$attrs:e=>ce(e.attrs),$slots:e=>ce(e.slots),$refs:e=>ce(e.refs),$parent:e=>He(e.parent),$root:e=>He(e.root),$emit:e=>e.emit,$options:e=>__VUE_OPTIONS_API__?Yn(e):e.type,$forceUpdate:e=>e.f||(e.f=()=>ve(e.update)),$nextTick:e=>e.n||(e.n=An.bind(e.proxy)),$watch:e=>__VUE_OPTIONS_API__?qn.bind(e):le}),Ne=(e,t)=>e!==A&&!e.__isScriptSetup&&h(e,t),Jn={get({_:e},t){const{ctx:n,setupState:o,data:r,props:s,accessCache:i,type:c,appContext:a}=e;if(t==="__isVue")return!0;let l;if(t[0]!=="$"){const F=i[t];if(F!==void 0)switch(F){case 1:return o[t];case 2:return r[t];case 4:return n[t];case 3:return s[t]}else{if(Ne(o,t))return i[t]=1,o[t];if(r!==A&&h(r,t))return i[t]=2,r[t];if((l=e.propsOptions[0])&&h(l,t))return i[t]=3,s[t];if(n!==A&&h(n,t))return i[t]=4,n[t];(!__VUE_OPTIONS_API__||Ln)&&(i[t]=0)}}const p=X[t];let d,S;if(p)return t==="$attrs"&&m(e,"get",t),p(e);if((d=c.__cssModules)&&(d=d[t]))return d;if(n!==A&&h(n,t))return i[t]=4,n[t];if(S=a.config.globalProperties,h(S,t))return S[t]},set({_:e},t,n){const{data:o,setupState:r,ctx:s}=e;return Ne(r,t)?(r[t]=n,!0):r.__isScriptSetup&&h(r,t)?(_(`Cannot mutate <script setup> binding "${t}" from Options API.`),!1):o!==A&&h(o,t)?(o[t]=n,!0):h(e.props,t)?(_(`Attempting to mutate prop "${t}". Props are readonly.`),!1):t[0]==="$"&&t.slice(1)in e?(_(`Attempting to mutate public property "${t}". Properties starting with $ are reserved and readonly.`),!1):(t in e.appContext.config.globalProperties?Object.defineProperty(s,t,{enumerable:!0,configurable:!0,value:n}):s[t]=n,!0)},has({_:{data:e,setupState:t,accessCache:n,ctx:o,appContext:r,propsOptions:s}},i){let c;return!!n[i]||e!==A&&h(e,i)||Ne(t,i)||(c=s[0])&&h(c,i)||h(o,i)||h(X,i)||h(r.config.globalProperties,i)},defineProperty(e,t,n){return n.get!=null?e._.accessCache[t]=0:h(n,"value")&&this.set(e,t,n.value,null),Reflect.defineProperty(e,t,n)}};Jn.ownKeys=e=>(_("Avoid app logic that relies on enumerating keys on a component instance. The keys will be empty in production mode to avoid performance overhead."),Reflect.ownKeys(e));let Ln=!0;function Yn(e){const t=e.type,{mixins:n,extends:o}=t,{mixins:r,optionsCache:s,config:{optionMergeStrategies:i}}=e.appContext,c=s.get(t);let a;return c?a=c:!r.length&&!n&&!o?a=t:(a={},r.length&&r.forEach(l=>he(a,l,i,!0)),he(a,t,i)),Re(t)&&s.set(t,a),a}function he(e,t,n,o=!1){const{mixins:r,extends:s}=t;s&&he(e,s,n,!0),r&&r.forEach(i=>he(e,i,n,!0));for(const i in t)if(o&&i==="expose")_('"expose" option is ignored when declared in mixins or extends. It should only be declared in the base component itself.');else{const c=Qn[i]||n&&n[i];e[i]=c?c(e[i],t[i]):t[i]}return e}const Qn={data:Tt,props:K,emits:K,methods:K,computed:K,beforeCreate:g,created:g,beforeMount:g,mounted:g,beforeUpdate:g,updated:g,beforeDestroy:g,beforeUnmount:g,destroyed:g,unmounted:g,activated:g,deactivated:g,errorCaptured:g,serverPrefetch:g,components:K,directives:K,watch:Zn,provide:Tt,inject:Xn};function Tt(e,t){return t?e?function(){return z(b(e)?e.call(this,this):e,b(t)?t.call(this,this):t)}:t:e}function Xn(e,t){return K(It(e),It(t))}function It(e){if(J(e)){const t={};for(let n=0;n<e.length;n++)t[e[n]]=e[n];return t}return e}function g(e,t){return e?[...new Set([].concat(e,t))]:t}function K(e,t){return e?z(z(Object.create(null),e),t):t}function Zn(e,t){if(!e)return t;if(!t)return e;const n=z(Object.create(null),e);for(const o in t)n[o]=g(e[o],t[o]);return n}function kn(){return{app:null,config:{isNativeTag:_n,performance:!1,globalProperties:{},optionMergeStrategies:{},errorHandler:void 0,warnHandler:void 0,compilerOptions:{}},mixins:[],components:{},directives:{},provides:Object.create(null),optionsCache:new WeakMap,propsCache:new WeakMap,emitsCache:new WeakMap}}const $t=Vn;kn();let I=null;const Mt=e=>{I=e,e.scope.on()},er=()=>{I&&I.scope.off(),I=null};function tr(e){return e.vnode.shapeFlag&4}let nr=!1;function rr(e){if(e.exposed)return e.exposeProxy||(e.exposeProxy=new Proxy(wn(dn(e.exposed)),{get(t,n){if(n in t)return t[n];if(n in X)return X[n](e)},has(t,n){return n in t||n in X}}))}const or=/(?:^|[-_])(\w)/g,sr=e=>e.replace(or,t=>t.toUpperCase()).replace(/[-_]/g,"");function Et(e,t=!0){return b(e)?e.displayName||e.name:e.name||t&&e.__name}function Rt(e,t,n=!1){let o=Et(t);if(!o&&t.__file){const r=t.__file.match(/([^/\\]+)\.\w+$/);r&&(o=r[1])}if(!o&&e&&e.parent){const r=s=>{for(const i in s)if(s[i]===t)return i};o=r(e.components||e.parent.type.components)||r(e.appContext.components)}return o?sr(o):n?"App":"Anonymous"}function ir(e){return b(e)&&"__vccOpts"in e}const cr=Symbol("ssrContext"),ar=()=>{{const e=Dn(cr);return e||_("Server rendering context not provided. Make sure to only call useSSRContext() conditionally in the server build."),e}};typeof globalThis.postToNative>"u"&&async function(){const e=function(...r){var s,i,c;(c=(i=(s=window.webkit)==null?void 0:s.messageHandlers)==null?void 0:i.logHandler)==null||c.postMessage(r.join(" "))},t=window.webkit?function(r){var s,i,c;(c=(i=(s=window.webkit)==null?void 0:s.messageHandlers)==null?void 0:i.native)==null||c.postMessage(r)}:function(r){console.log("%c postToNative %o","background: #222; color: #bada55",r)},n=function(r,s){globalThis.hasOwnProperty(r)||Object.defineProperty(globalThis,r,{value:s,writable:!1})};let o=Te({});Gn(()=>o,function(r){var s,i,c;(c=(i=(s=window.webkit)==null?void 0:s.messageHandlers)==null?void 0:i.webViewBridge)==null||c.postMessage(f(r))},{deep:!0}),n("bridge",o),n("postToNative",t),window.webkit&&(window.console.log=e,window.console.warn=e,window.console.error=e,window.onerror=e)}()});
