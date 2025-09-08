function vs(Ut) {
  return Ut && Ut.__esModule && Object.prototype.hasOwnProperty.call(Ut, "default") ? Ut.default : Ut;
}
var me = { exports: {} }, xs = me.exports, Ir;
function Ts() {
  return Ir || (Ir = 1, function(Ut, Nr) {
    (function(C, ge) {
      ge(Nr);
    })(xs, function(C) {
      function ge(u, t) {
        u.prototype = Object.create(t.prototype), u.prototype.constructor = u, u.__proto__ = t;
      }
      function mt(u) {
        if (u === void 0)
          throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
        return u;
      }
      /*!
       * GSAP 3.13.0
       * https://gsap.com
       *
       * @license Copyright 2008-2025, GreenSock. All rights reserved.
       * Subject to the terms at https://gsap.com/standard-license
       * @author: Jack Doyle, jack@greensock.com
      */
      var et = {
        autoSleep: 120,
        force3D: "auto",
        nullTargetWarn: 1,
        units: {
          lineHeight: ""
        }
      }, Yt = {
        duration: 0.5,
        overwrite: !1,
        delay: 0
      }, Ee, G, E, ot = 1e8, M = 1 / ot, ze = Math.PI * 2, Br = ze / 4, Vr = 0, wi = Math.sqrt, Ur = Math.cos, Yr = Math.sin, Y = function(t) {
        return typeof t == "string";
      }, I = function(t) {
        return typeof t == "function";
      }, gt = function(t) {
        return typeof t == "number";
      }, Fe = function(t) {
        return typeof t > "u";
      }, lt = function(t) {
        return typeof t == "object";
      }, K = function(t) {
        return t !== !1;
      }, Le = function() {
        return typeof window < "u";
      }, ye = function(t) {
        return I(t) || Y(t);
      }, bi = typeof ArrayBuffer == "function" && ArrayBuffer.isView || function() {
      }, $ = Array.isArray, Ie = /(?:-?\.?\d|\.)+/gi, Pi = /[-+=.]*\d+[.e\-+]*\d*[e\-+]*\d*/g, Xt = /[-+=.]*\d+[.e-]*\d*[a-z%]*/g, Ne = /[-+=.]*\d+\.?\d*(?:e-|e\+)?\d*/gi, Si = /[+-]=-?[.\d]+/, Oi = /[^,'"\[\]\s]+/gi, Xr = /^[+\-=e\s\d]*\d+[.\d]*([a-z]*|%)\s*$/i, F, ct, Be, Ve, it = {}, ve = {}, ki, Ci = function(t) {
        return (ve = Gt(t, it)) && J;
      }, Ue = function(t, e) {
        return console.warn("Invalid property", t, "set to", e, "Missing plugin? gsap.registerPlugin()");
      }, te = function(t, e) {
        return !e && console.warn(t);
      }, Mi = function(t, e) {
        return t && (it[t] = e) && ve && (ve[t] = e) || it;
      }, ee = function() {
        return 0;
      }, qr = {
        suppressEvents: !0,
        isStart: !0,
        kill: !1
      }, xe = {
        suppressEvents: !0,
        kill: !1
      }, Gr = {
        suppressEvents: !0
      }, Ye = {}, Tt = [], Xe = {}, Di, rt = {}, qe = {}, Ai = 30, Te = [], Ge = "", We = function(t) {
        var e = t[0], i, r;
        if (lt(e) || I(e) || (t = [t]), !(i = (e._gsap || {}).harness)) {
          for (r = Te.length; r-- && !Te[r].targetTest(e); )
            ;
          i = Te[r];
        }
        for (r = t.length; r--; )
          t[r] && (t[r]._gsap || (t[r]._gsap = new ar(t[r], i))) || t.splice(r, 1);
        return t;
      }, Mt = function(t) {
        return t._gsap || We(ft(t))[0]._gsap;
      }, Ri = function(t, e, i) {
        return (i = t[e]) && I(i) ? t[e]() : Fe(i) && t.getAttribute && t.getAttribute(e) || i;
      }, Z = function(t, e) {
        return (t = t.split(",")).forEach(e) || t;
      }, N = function(t) {
        return Math.round(t * 1e5) / 1e5 || 0;
      }, V = function(t) {
        return Math.round(t * 1e7) / 1e7 || 0;
      }, qt = function(t, e) {
        var i = e.charAt(0), r = parseFloat(e.substr(2));
        return t = parseFloat(t), i === "+" ? t + r : i === "-" ? t - r : i === "*" ? t * r : t / r;
      }, Wr = function(t, e) {
        for (var i = e.length, r = 0; t.indexOf(e[r]) < 0 && ++r < i; )
          ;
        return r < i;
      }, we = function() {
        var t = Tt.length, e = Tt.slice(0), i, r;
        for (Xe = {}, Tt.length = 0, i = 0; i < t; i++)
          r = e[i], r && r._lazy && (r.render(r._lazy[0], r._lazy[1], !0)._lazy = 0);
      }, Qe = function(t) {
        return !!(t._initted || t._startAt || t.add);
      }, Ei = function(t, e, i, r) {
        Tt.length && !G && we(), t.render(e, i, !!(G && e < 0 && Qe(t))), Tt.length && !G && we();
      }, zi = function(t) {
        var e = parseFloat(t);
        return (e || e === 0) && (t + "").match(Oi).length < 2 ? e : Y(t) ? t.trim() : t;
      }, Fi = function(t) {
        return t;
      }, nt = function(t, e) {
        for (var i in e)
          i in t || (t[i] = e[i]);
        return t;
      }, Qr = function(t) {
        return function(e, i) {
          for (var r in i)
            r in e || r === "duration" && t || r === "ease" || (e[r] = i[r]);
        };
      }, Gt = function(t, e) {
        for (var i in e)
          t[i] = e[i];
        return t;
      }, Li = function u(t, e) {
        for (var i in e)
          i !== "__proto__" && i !== "constructor" && i !== "prototype" && (t[i] = lt(e[i]) ? u(t[i] || (t[i] = {}), e[i]) : e[i]);
        return t;
      }, be = function(t, e) {
        var i = {}, r;
        for (r in t)
          r in e || (i[r] = t[r]);
        return i;
      }, ie = function(t) {
        var e = t.parent || F, i = t.keyframes ? Qr($(t.keyframes)) : nt;
        if (K(t.inherit))
          for (; e; )
            i(t, e.vars.defaults), e = e.parent || e._dp;
        return t;
      }, $r = function(t, e) {
        for (var i = t.length, r = i === e.length; r && i-- && t[i] === e[i]; )
          ;
        return i < 0;
      }, Ii = function(t, e, i, r, n) {
        var s = t[r], a;
        if (n)
          for (a = e[n]; s && s[n] > a; )
            s = s._prev;
        return s ? (e._next = s._next, s._next = e) : (e._next = t[i], t[i] = e), e._next ? e._next._prev = e : t[r] = e, e._prev = s, e.parent = e._dp = t, e;
      }, Pe = function(t, e, i, r) {
        i === void 0 && (i = "_first"), r === void 0 && (r = "_last");
        var n = e._prev, s = e._next;
        n ? n._next = s : t[i] === e && (t[i] = s), s ? s._prev = n : t[r] === e && (t[r] = n), e._next = e._prev = e.parent = null;
      }, wt = function(t, e) {
        t.parent && (!e || t.parent.autoRemoveChildren) && t.parent.remove && t.parent.remove(t), t._act = 0;
      }, Dt = function(t, e) {
        if (t && (!e || e._end > t._dur || e._start < 0))
          for (var i = t; i; )
            i._dirty = 1, i = i.parent;
        return t;
      }, jr = function(t) {
        for (var e = t.parent; e && e.parent; )
          e._dirty = 1, e.totalDuration(), e = e.parent;
        return t;
      }, $e = function(t, e, i, r) {
        return t._startAt && (G ? t._startAt.revert(xe) : t.vars.immediateRender && !t.vars.autoRevert || t._startAt.render(e, !0, r));
      }, Kr = function u(t) {
        return !t || t._ts && u(t.parent);
      }, Ni = function(t) {
        return t._repeat ? Wt(t._tTime, t = t.duration() + t._rDelay) * t : 0;
      }, Wt = function(t, e) {
        var i = Math.floor(t = V(t / e));
        return t && i === t ? i - 1 : i;
      }, Se = function(t, e) {
        return (t - e._start) * e._ts + (e._ts >= 0 ? 0 : e._dirty ? e.totalDuration() : e._tDur);
      }, Oe = function(t) {
        return t._end = V(t._start + (t._tDur / Math.abs(t._ts || t._rts || M) || 0));
      }, ke = function(t, e) {
        var i = t._dp;
        return i && i.smoothChildTiming && t._ts && (t._start = V(i._time - (t._ts > 0 ? e / t._ts : ((t._dirty ? t.totalDuration() : t._tDur) - e) / -t._ts)), Oe(t), i._dirty || Dt(i, t)), t;
      }, Bi = function(t, e) {
        var i;
        if ((e._time || !e._dur && e._initted || e._start < t._time && (e._dur || !e.add)) && (i = Se(t.rawTime(), e), (!e._dur || ne(0, e.totalDuration(), i) - e._tTime > M) && e.render(i, !0)), Dt(t, e)._dp && t._initted && t._time >= t._dur && t._ts) {
          if (t._dur < t.duration())
            for (i = t; i._dp; )
              i.rawTime() >= 0 && i.totalTime(i._tTime), i = i._dp;
          t._zTime = -M;
        }
      }, dt = function(t, e, i, r) {
        return e.parent && wt(e), e._start = V((gt(i) ? i : i || t !== F ? ut(t, i, e) : t._time) + e._delay), e._end = V(e._start + (e.totalDuration() / Math.abs(e.timeScale()) || 0)), Ii(t, e, "_first", "_last", t._sort ? "_start" : 0), je(e) || (t._recent = e), r || Bi(t, e), t._ts < 0 && ke(t, t._tTime), t;
      }, Vi = function(t, e) {
        return (it.ScrollTrigger || Ue("scrollTrigger", e)) && it.ScrollTrigger.create(e, t);
      }, Ui = function(t, e, i, r, n) {
        if (ni(t, e, n), !t._initted)
          return 1;
        if (!i && t._pt && !G && (t._dur && t.vars.lazy !== !1 || !t._dur && t.vars.lazy) && Di !== at.frame)
          return Tt.push(t), t._lazy = [n, r], 1;
      }, Zr = function u(t) {
        var e = t.parent;
        return e && e._ts && e._initted && !e._lock && (e.rawTime() < 0 || u(e));
      }, je = function(t) {
        var e = t.data;
        return e === "isFromStart" || e === "isStart";
      }, Hr = function(t, e, i, r) {
        var n = t.ratio, s = e < 0 || !e && (!t._start && Zr(t) && !(!t._initted && je(t)) || (t._ts < 0 || t._dp._ts < 0) && !je(t)) ? 0 : 1, a = t._rDelay, o = 0, f, h, l;
        if (a && t._repeat && (o = ne(0, t._tDur, e), h = Wt(o, a), t._yoyo && h & 1 && (s = 1 - s), h !== Wt(t._tTime, a) && (n = 1 - s, t.vars.repeatRefresh && t._initted && t.invalidate())), s !== n || G || r || t._zTime === M || !e && t._zTime) {
          if (!t._initted && Ui(t, e, r, i, o))
            return;
          for (l = t._zTime, t._zTime = e || (i ? M : 0), i || (i = e && !l), t.ratio = s, t._from && (s = 1 - s), t._time = 0, t._tTime = o, f = t._pt; f; )
            f.r(s, f.d), f = f._next;
          e < 0 && $e(t, e, i, !0), t._onUpdate && !i && st(t, "onUpdate"), o && t._repeat && !i && t.parent && st(t, "onRepeat"), (e >= t._tDur || e < 0) && t.ratio === s && (s && wt(t, 1), !i && !G && (st(t, s ? "onComplete" : "onReverseComplete", !0), t._prom && t._prom()));
        } else t._zTime || (t._zTime = e);
      }, Jr = function(t, e, i) {
        var r;
        if (i > e)
          for (r = t._first; r && r._start <= i; ) {
            if (r.data === "isPause" && r._start > e)
              return r;
            r = r._next;
          }
        else
          for (r = t._last; r && r._start >= i; ) {
            if (r.data === "isPause" && r._start < e)
              return r;
            r = r._prev;
          }
      }, Qt = function(t, e, i, r) {
        var n = t._repeat, s = V(e) || 0, a = t._tTime / t._tDur;
        return a && !r && (t._time *= s / t._dur), t._dur = s, t._tDur = n ? n < 0 ? 1e10 : V(s * (n + 1) + t._rDelay * n) : s, a > 0 && !r && ke(t, t._tTime = t._tDur * a), t.parent && Oe(t), i || Dt(t.parent, t), t;
      }, Yi = function(t) {
        return t instanceof W ? Dt(t) : Qt(t, t._dur);
      }, tn = {
        _start: 0,
        endTime: ee,
        totalDuration: ee
      }, ut = function u(t, e, i) {
        var r = t.labels, n = t._recent || tn, s = t.duration() >= ot ? n.endTime(!1) : t._dur, a, o, f;
        return Y(e) && (isNaN(e) || e in r) ? (o = e.charAt(0), f = e.substr(-1) === "%", a = e.indexOf("="), o === "<" || o === ">" ? (a >= 0 && (e = e.replace(/=/, "")), (o === "<" ? n._start : n.endTime(n._repeat >= 0)) + (parseFloat(e.substr(1)) || 0) * (f ? (a < 0 ? n : i).totalDuration() / 100 : 1)) : a < 0 ? (e in r || (r[e] = s), r[e]) : (o = parseFloat(e.charAt(a - 1) + e.substr(a + 1)), f && i && (o = o / 100 * ($(i) ? i[0] : i).totalDuration()), a > 1 ? u(t, e.substr(0, a - 1), i) + o : s + o)) : e == null ? s : +e;
      }, re = function(t, e, i) {
        var r = gt(e[1]), n = (r ? 2 : 1) + (t < 2 ? 0 : 1), s = e[n], a, o;
        if (r && (s.duration = e[1]), s.parent = i, t) {
          for (a = s, o = i; o && !("immediateRender" in a); )
            a = o.vars.defaults || {}, o = K(o.vars.inherit) && o.parent;
          s.immediateRender = K(a.immediateRender), t < 2 ? s.runBackwards = 1 : s.startAt = e[n - 1];
        }
        return new B(e[0], s, e[n + 1]);
      }, bt = function(t, e) {
        return t || t === 0 ? e(t) : e;
      }, ne = function(t, e, i) {
        return i < t ? t : i > e ? e : i;
      }, j = function(t, e) {
        return !Y(t) || !(e = Xr.exec(t)) ? "" : e[1];
      }, en = function(t, e, i) {
        return bt(i, function(r) {
          return ne(t, e, r);
        });
      }, Ke = [].slice, Xi = function(t, e) {
        return t && lt(t) && "length" in t && (!e && !t.length || t.length - 1 in t && lt(t[0])) && !t.nodeType && t !== ct;
      }, rn = function(t, e, i) {
        return i === void 0 && (i = []), t.forEach(function(r) {
          var n;
          return Y(r) && !e || Xi(r, 1) ? (n = i).push.apply(n, ft(r)) : i.push(r);
        }) || i;
      }, ft = function(t, e, i) {
        return E && !e && E.selector ? E.selector(t) : Y(t) && !i && (Be || !jt()) ? Ke.call((e || Ve).querySelectorAll(t), 0) : $(t) ? rn(t, i) : Xi(t) ? Ke.call(t, 0) : t ? [t] : [];
      }, Ze = function(t) {
        return t = ft(t)[0] || te("Invalid scope") || {}, function(e) {
          var i = t.current || t.nativeElement || t;
          return ft(e, i.querySelectorAll ? i : i === t ? te("Invalid scope") || Ve.createElement("div") : t);
        };
      }, qi = function(t) {
        return t.sort(function() {
          return 0.5 - Math.random();
        });
      }, Gi = function(t) {
        if (I(t))
          return t;
        var e = lt(t) ? t : {
          each: t
        }, i = At(e.ease), r = e.from || 0, n = parseFloat(e.base) || 0, s = {}, a = r > 0 && r < 1, o = isNaN(r) || a, f = e.axis, h = r, l = r;
        return Y(r) ? h = l = {
          center: 0.5,
          edges: 0.5,
          end: 1
        }[r] || 0 : !a && o && (h = r[0], l = r[1]), function(c, d, p) {
          var _ = (p || e).length, m = s[_], y, v, x, T, g, b, P, S, w;
          if (!m) {
            if (w = e.grid === "auto" ? 0 : (e.grid || [1, ot])[1], !w) {
              for (P = -ot; P < (P = p[w++].getBoundingClientRect().left) && w < _; )
                ;
              w < _ && w--;
            }
            for (m = s[_] = [], y = o ? Math.min(w, _) * h - 0.5 : r % w, v = w === ot ? 0 : o ? _ * l / w - 0.5 : r / w | 0, P = 0, S = ot, b = 0; b < _; b++)
              x = b % w - y, T = v - (b / w | 0), m[b] = g = f ? Math.abs(f === "y" ? T : x) : wi(x * x + T * T), g > P && (P = g), g < S && (S = g);
            r === "random" && qi(m), m.max = P - S, m.min = S, m.v = _ = (parseFloat(e.amount) || parseFloat(e.each) * (w > _ ? _ - 1 : f ? f === "y" ? _ / w : w : Math.max(w, _ / w)) || 0) * (r === "edges" ? -1 : 1), m.b = _ < 0 ? n - _ : n, m.u = j(e.amount || e.each) || 0, i = i && _ < 0 ? rr(i) : i;
          }
          return _ = (m[c] - m.min) / m.max || 0, V(m.b + (i ? i(_) : _) * m.v) + m.u;
        };
      }, He = function(t) {
        var e = Math.pow(10, ((t + "").split(".")[1] || "").length);
        return function(i) {
          var r = V(Math.round(parseFloat(i) / t) * t * e);
          return (r - r % 1) / e + (gt(i) ? 0 : j(i));
        };
      }, Wi = function(t, e) {
        var i = $(t), r, n;
        return !i && lt(t) && (r = i = t.radius || ot, t.values ? (t = ft(t.values), (n = !gt(t[0])) && (r *= r)) : t = He(t.increment)), bt(e, i ? I(t) ? function(s) {
          return n = t(s), Math.abs(n - s) <= r ? n : s;
        } : function(s) {
          for (var a = parseFloat(n ? s.x : s), o = parseFloat(n ? s.y : 0), f = ot, h = 0, l = t.length, c, d; l--; )
            n ? (c = t[l].x - a, d = t[l].y - o, c = c * c + d * d) : c = Math.abs(t[l] - a), c < f && (f = c, h = l);
          return h = !r || f <= r ? t[h] : s, n || h === s || gt(s) ? h : h + j(s);
        } : He(t));
      }, Qi = function(t, e, i, r) {
        return bt($(t) ? !e : i === !0 ? !!(i = 0) : !r, function() {
          return $(t) ? t[~~(Math.random() * t.length)] : (i = i || 1e-5) && (r = i < 1 ? Math.pow(10, (i + "").length - 2) : 1) && Math.floor(Math.round((t - i / 2 + Math.random() * (e - t + i * 0.99)) / i) * i * r) / r;
        });
      }, nn = function() {
        for (var t = arguments.length, e = new Array(t), i = 0; i < t; i++)
          e[i] = arguments[i];
        return function(r) {
          return e.reduce(function(n, s) {
            return s(n);
          }, r);
        };
      }, sn = function(t, e) {
        return function(i) {
          return t(parseFloat(i)) + (e || j(i));
        };
      }, an = function(t, e, i) {
        return ji(t, e, 0, 1, i);
      }, $i = function(t, e, i) {
        return bt(i, function(r) {
          return t[~~e(r)];
        });
      }, on = function u(t, e, i) {
        var r = e - t;
        return $(t) ? $i(t, u(0, t.length), e) : bt(i, function(n) {
          return (r + (n - t) % r) % r + t;
        });
      }, un = function u(t, e, i) {
        var r = e - t, n = r * 2;
        return $(t) ? $i(t, u(0, t.length - 1), e) : bt(i, function(s) {
          return s = (n + (s - t) % n) % n || 0, t + (s > r ? n - s : s);
        });
      }, se = function(t) {
        for (var e = 0, i = "", r, n, s, a; ~(r = t.indexOf("random(", e)); )
          s = t.indexOf(")", r), a = t.charAt(r + 7) === "[", n = t.substr(r + 7, s - r - 7).match(a ? Oi : Ie), i += t.substr(e, r - e) + Qi(a ? n : +n[0], a ? 0 : +n[1], +n[2] || 1e-5), e = s + 1;
        return i + t.substr(e, t.length - e);
      }, ji = function(t, e, i, r, n) {
        var s = e - t, a = r - i;
        return bt(n, function(o) {
          return i + ((o - t) / s * a || 0);
        });
      }, fn = function u(t, e, i, r) {
        var n = isNaN(t + e) ? 0 : function(d) {
          return (1 - d) * t + d * e;
        };
        if (!n) {
          var s = Y(t), a = {}, o, f, h, l, c;
          if (i === !0 && (r = 1) && (i = null), s)
            t = {
              p: t
            }, e = {
              p: e
            };
          else if ($(t) && !$(e)) {
            for (h = [], l = t.length, c = l - 2, f = 1; f < l; f++)
              h.push(u(t[f - 1], t[f]));
            l--, n = function(p) {
              p *= l;
              var _ = Math.min(c, ~~p);
              return h[_](p - _);
            }, i = e;
          } else r || (t = Gt($(t) ? [] : {}, t));
          if (!h) {
            for (o in e)
              ii.call(a, t, o, "get", e[o]);
            n = function(p) {
              return oi(p, a) || (s ? t.p : t);
            };
          }
        }
        return bt(i, n);
      }, Ki = function(t, e, i) {
        var r = t.labels, n = ot, s, a, o;
        for (s in r)
          a = r[s] - e, a < 0 == !!i && a && n > (a = Math.abs(a)) && (o = s, n = a);
        return o;
      }, st = function(t, e, i) {
        var r = t.vars, n = r[e], s = E, a = t._ctx, o, f, h;
        if (n)
          return o = r[e + "Params"], f = r.callbackScope || t, i && Tt.length && we(), a && (E = a), h = o ? n.apply(f, o) : n.call(f), E = s, h;
      }, ae = function(t) {
        return wt(t), t.scrollTrigger && t.scrollTrigger.kill(!!G), t.progress() < 1 && st(t, "onInterrupt"), t;
      }, $t, Zi = [], Hi = function(t) {
        if (t)
          if (t = !t.name && t.default || t, Le() || t.headless) {
            var e = t.name, i = I(t), r = e && !i && t.init ? function() {
              this._props = [];
            } : t, n = {
              init: ee,
              render: oi,
              add: ii,
              kill: Sn,
              modifier: Pn,
              rawVars: 0
            }, s = {
              targetTest: 0,
              get: 0,
              getSetter: ai,
              aliases: {},
              register: 0
            };
            if (jt(), t !== r) {
              if (rt[e])
                return;
              nt(r, nt(be(t, n), s)), Gt(r.prototype, Gt(n, be(t, s))), rt[r.prop = e] = r, t.targetTest && (Te.push(r), Ye[e] = 1), e = (e === "css" ? "CSS" : e.charAt(0).toUpperCase() + e.substr(1)) + "Plugin";
            }
            Mi(e, r), t.register && t.register(J, r, H);
          } else
            Zi.push(t);
      }, D = 255, oe = {
        aqua: [0, D, D],
        lime: [0, D, 0],
        silver: [192, 192, 192],
        black: [0, 0, 0],
        maroon: [128, 0, 0],
        teal: [0, 128, 128],
        blue: [0, 0, D],
        navy: [0, 0, 128],
        white: [D, D, D],
        olive: [128, 128, 0],
        yellow: [D, D, 0],
        orange: [D, 165, 0],
        gray: [128, 128, 128],
        purple: [128, 0, 128],
        green: [0, 128, 0],
        red: [D, 0, 0],
        pink: [D, 192, 203],
        cyan: [0, D, D],
        transparent: [D, D, D, 0]
      }, Je = function(t, e, i) {
        return t += t < 0 ? 1 : t > 1 ? -1 : 0, (t * 6 < 1 ? e + (i - e) * t * 6 : t < 0.5 ? i : t * 3 < 2 ? e + (i - e) * (2 / 3 - t) * 6 : e) * D + 0.5 | 0;
      }, Ji = function(t, e, i) {
        var r = t ? gt(t) ? [t >> 16, t >> 8 & D, t & D] : 0 : oe.black, n, s, a, o, f, h, l, c, d, p;
        if (!r) {
          if (t.substr(-1) === "," && (t = t.substr(0, t.length - 1)), oe[t])
            r = oe[t];
          else if (t.charAt(0) === "#") {
            if (t.length < 6 && (n = t.charAt(1), s = t.charAt(2), a = t.charAt(3), t = "#" + n + n + s + s + a + a + (t.length === 5 ? t.charAt(4) + t.charAt(4) : "")), t.length === 9)
              return r = parseInt(t.substr(1, 6), 16), [r >> 16, r >> 8 & D, r & D, parseInt(t.substr(7), 16) / 255];
            t = parseInt(t.substr(1), 16), r = [t >> 16, t >> 8 & D, t & D];
          } else if (t.substr(0, 3) === "hsl") {
            if (r = p = t.match(Ie), !e)
              o = +r[0] % 360 / 360, f = +r[1] / 100, h = +r[2] / 100, s = h <= 0.5 ? h * (f + 1) : h + f - h * f, n = h * 2 - s, r.length > 3 && (r[3] *= 1), r[0] = Je(o + 1 / 3, n, s), r[1] = Je(o, n, s), r[2] = Je(o - 1 / 3, n, s);
            else if (~t.indexOf("="))
              return r = t.match(Pi), i && r.length < 4 && (r[3] = 1), r;
          } else
            r = t.match(Ie) || oe.transparent;
          r = r.map(Number);
        }
        return e && !p && (n = r[0] / D, s = r[1] / D, a = r[2] / D, l = Math.max(n, s, a), c = Math.min(n, s, a), h = (l + c) / 2, l === c ? o = f = 0 : (d = l - c, f = h > 0.5 ? d / (2 - l - c) : d / (l + c), o = l === n ? (s - a) / d + (s < a ? 6 : 0) : l === s ? (a - n) / d + 2 : (n - s) / d + 4, o *= 60), r[0] = ~~(o + 0.5), r[1] = ~~(f * 100 + 0.5), r[2] = ~~(h * 100 + 0.5)), i && r.length < 4 && (r[3] = 1), r;
      }, tr = function(t) {
        var e = [], i = [], r = -1;
        return t.split(Pt).forEach(function(n) {
          var s = n.match(Xt) || [];
          e.push.apply(e, s), i.push(r += s.length + 1);
        }), e.c = i, e;
      }, er = function(t, e, i) {
        var r = "", n = (t + r).match(Pt), s = e ? "hsla(" : "rgba(", a = 0, o, f, h, l;
        if (!n)
          return t;
        if (n = n.map(function(c) {
          return (c = Ji(c, e, 1)) && s + (e ? c[0] + "," + c[1] + "%," + c[2] + "%," + c[3] : c.join(",")) + ")";
        }), i && (h = tr(t), o = i.c, o.join(r) !== h.c.join(r)))
          for (f = t.replace(Pt, "1").split(Xt), l = f.length - 1; a < l; a++)
            r += f[a] + (~o.indexOf(a) ? n.shift() || s + "0,0,0,0)" : (h.length ? h : n.length ? n : i).shift());
        if (!f)
          for (f = t.split(Pt), l = f.length - 1; a < l; a++)
            r += f[a] + n[a];
        return r + f[l];
      }, Pt = function() {
        var u = "(?:\\b(?:(?:rgb|rgba|hsl|hsla)\\(.+?\\))|\\B#(?:[0-9a-f]{3,4}){1,2}\\b", t;
        for (t in oe)
          u += "|" + t + "\\b";
        return new RegExp(u + ")", "gi");
      }(), hn = /hsl[a]?\(/, ir = function(t) {
        var e = t.join(" "), i;
        if (Pt.lastIndex = 0, Pt.test(e))
          return i = hn.test(e), t[1] = er(t[1], i), t[0] = er(t[0], i, tr(t[1])), !0;
      }, ue, at = function() {
        var u = Date.now, t = 500, e = 33, i = u(), r = i, n = 1e3 / 240, s = n, a = [], o, f, h, l, c, d, p = function _(m) {
          var y = u() - r, v = m === !0, x, T, g, b;
          if ((y > t || y < 0) && (i += y - e), r += y, g = r - i, x = g - s, (x > 0 || v) && (b = ++l.frame, c = g - l.time * 1e3, l.time = g = g / 1e3, s += x + (x >= n ? 4 : n - x), T = 1), v || (o = f(_)), T)
            for (d = 0; d < a.length; d++)
              a[d](g, c, b, m);
        };
        return l = {
          time: 0,
          frame: 0,
          tick: function() {
            p(!0);
          },
          deltaRatio: function(m) {
            return c / (1e3 / (m || 60));
          },
          wake: function() {
            ki && (!Be && Le() && (ct = Be = window, Ve = ct.document || {}, it.gsap = J, (ct.gsapVersions || (ct.gsapVersions = [])).push(J.version), Ci(ve || ct.GreenSockGlobals || !ct.gsap && ct || {}), Zi.forEach(Hi)), h = typeof requestAnimationFrame < "u" && requestAnimationFrame, o && l.sleep(), f = h || function(m) {
              return setTimeout(m, s - l.time * 1e3 + 1 | 0);
            }, ue = 1, p(2));
          },
          sleep: function() {
            (h ? cancelAnimationFrame : clearTimeout)(o), ue = 0, f = ee;
          },
          lagSmoothing: function(m, y) {
            t = m || 1 / 0, e = Math.min(y || 33, t);
          },
          fps: function(m) {
            n = 1e3 / (m || 240), s = l.time * 1e3 + n;
          },
          add: function(m, y, v) {
            var x = y ? function(T, g, b, P) {
              m(T, g, b, P), l.remove(x);
            } : m;
            return l.remove(m), a[v ? "unshift" : "push"](x), jt(), x;
          },
          remove: function(m, y) {
            ~(y = a.indexOf(m)) && a.splice(y, 1) && d >= y && d--;
          },
          _listeners: a
        }, l;
      }(), jt = function() {
        return !ue && at.wake();
      }, O = {}, _n = /^[\d.\-M][\d.\-,\s]/, ln = /["']/g, cn = function(t) {
        for (var e = {}, i = t.substr(1, t.length - 3).split(":"), r = i[0], n = 1, s = i.length, a, o, f; n < s; n++)
          o = i[n], a = n !== s - 1 ? o.lastIndexOf(",") : o.length, f = o.substr(0, a), e[r] = isNaN(f) ? f.replace(ln, "").trim() : +f, r = o.substr(a + 1).trim();
        return e;
      }, dn = function(t) {
        var e = t.indexOf("(") + 1, i = t.indexOf(")"), r = t.indexOf("(", e);
        return t.substring(e, ~r && r < i ? t.indexOf(")", i + 1) : i);
      }, pn = function(t) {
        var e = (t + "").split("("), i = O[e[0]];
        return i && e.length > 1 && i.config ? i.config.apply(null, ~t.indexOf("{") ? [cn(e[1])] : dn(t).split(",").map(zi)) : O._CE && _n.test(t) ? O._CE("", t) : i;
      }, rr = function(t) {
        return function(e) {
          return 1 - t(1 - e);
        };
      }, nr = function u(t, e) {
        for (var i = t._first, r; i; )
          i instanceof W ? u(i, e) : i.vars.yoyoEase && (!i._yoyo || !i._repeat) && i._yoyo !== e && (i.timeline ? u(i.timeline, e) : (r = i._ease, i._ease = i._yEase, i._yEase = r, i._yoyo = e)), i = i._next;
      }, At = function(t, e) {
        return t && (I(t) ? t : O[t] || pn(t)) || e;
      }, Rt = function(t, e, i, r) {
        i === void 0 && (i = function(o) {
          return 1 - e(1 - o);
        }), r === void 0 && (r = function(o) {
          return o < 0.5 ? e(o * 2) / 2 : 1 - e((1 - o) * 2) / 2;
        });
        var n = {
          easeIn: e,
          easeOut: i,
          easeInOut: r
        }, s;
        return Z(t, function(a) {
          O[a] = it[a] = n, O[s = a.toLowerCase()] = i;
          for (var o in n)
            O[s + (o === "easeIn" ? ".in" : o === "easeOut" ? ".out" : ".inOut")] = O[a + "." + o] = n[o];
        }), n;
      }, sr = function(t) {
        return function(e) {
          return e < 0.5 ? (1 - t(1 - e * 2)) / 2 : 0.5 + t((e - 0.5) * 2) / 2;
        };
      }, ti = function u(t, e, i) {
        var r = e >= 1 ? e : 1, n = (i || (t ? 0.3 : 0.45)) / (e < 1 ? e : 1), s = n / ze * (Math.asin(1 / r) || 0), a = function(h) {
          return h === 1 ? 1 : r * Math.pow(2, -10 * h) * Yr((h - s) * n) + 1;
        }, o = t === "out" ? a : t === "in" ? function(f) {
          return 1 - a(1 - f);
        } : sr(a);
        return n = ze / n, o.config = function(f, h) {
          return u(t, f, h);
        }, o;
      }, ei = function u(t, e) {
        e === void 0 && (e = 1.70158);
        var i = function(s) {
          return s ? --s * s * ((e + 1) * s + e) + 1 : 0;
        }, r = t === "out" ? i : t === "in" ? function(n) {
          return 1 - i(1 - n);
        } : sr(i);
        return r.config = function(n) {
          return u(t, n);
        }, r;
      };
      Z("Linear,Quad,Cubic,Quart,Quint,Strong", function(u, t) {
        var e = t < 5 ? t + 1 : t;
        Rt(u + ",Power" + (e - 1), t ? function(i) {
          return Math.pow(i, e);
        } : function(i) {
          return i;
        }, function(i) {
          return 1 - Math.pow(1 - i, e);
        }, function(i) {
          return i < 0.5 ? Math.pow(i * 2, e) / 2 : 1 - Math.pow((1 - i) * 2, e) / 2;
        });
      }), O.Linear.easeNone = O.none = O.Linear.easeIn, Rt("Elastic", ti("in"), ti("out"), ti()), function(u, t) {
        var e = 1 / t, i = 2 * e, r = 2.5 * e, n = function(a) {
          return a < e ? u * a * a : a < i ? u * Math.pow(a - 1.5 / t, 2) + 0.75 : a < r ? u * (a -= 2.25 / t) * a + 0.9375 : u * Math.pow(a - 2.625 / t, 2) + 0.984375;
        };
        Rt("Bounce", function(s) {
          return 1 - n(1 - s);
        }, n);
      }(7.5625, 2.75), Rt("Expo", function(u) {
        return Math.pow(2, 10 * (u - 1)) * u + u * u * u * u * u * u * (1 - u);
      }), Rt("Circ", function(u) {
        return -(wi(1 - u * u) - 1);
      }), Rt("Sine", function(u) {
        return u === 1 ? 1 : -Ur(u * Br) + 1;
      }), Rt("Back", ei("in"), ei("out"), ei()), O.SteppedEase = O.steps = it.SteppedEase = {
        config: function(t, e) {
          t === void 0 && (t = 1);
          var i = 1 / t, r = t + (e ? 0 : 1), n = e ? 1 : 0, s = 1 - M;
          return function(a) {
            return ((r * ne(0, s, a) | 0) + n) * i;
          };
        }
      }, Yt.ease = O["quad.out"], Z("onComplete,onUpdate,onStart,onRepeat,onReverseComplete,onInterrupt", function(u) {
        return Ge += u + "," + u + "Params,";
      });
      var ar = function(t, e) {
        this.id = Vr++, t._gsap = this, this.target = t, this.harness = e, this.get = e ? e.get : Ri, this.set = e ? e.getSetter : ai;
      }, fe = function() {
        function u(e) {
          this.vars = e, this._delay = +e.delay || 0, (this._repeat = e.repeat === 1 / 0 ? -2 : e.repeat || 0) && (this._rDelay = e.repeatDelay || 0, this._yoyo = !!e.yoyo || !!e.yoyoEase), this._ts = 1, Qt(this, +e.duration, 1, 1), this.data = e.data, E && (this._ctx = E, E.data.push(this)), ue || at.wake();
        }
        var t = u.prototype;
        return t.delay = function(i) {
          return i || i === 0 ? (this.parent && this.parent.smoothChildTiming && this.startTime(this._start + i - this._delay), this._delay = i, this) : this._delay;
        }, t.duration = function(i) {
          return arguments.length ? this.totalDuration(this._repeat > 0 ? i + (i + this._rDelay) * this._repeat : i) : this.totalDuration() && this._dur;
        }, t.totalDuration = function(i) {
          return arguments.length ? (this._dirty = 0, Qt(this, this._repeat < 0 ? i : (i - this._repeat * this._rDelay) / (this._repeat + 1))) : this._tDur;
        }, t.totalTime = function(i, r) {
          if (jt(), !arguments.length)
            return this._tTime;
          var n = this._dp;
          if (n && n.smoothChildTiming && this._ts) {
            for (ke(this, i), !n._dp || n.parent || Bi(n, this); n && n.parent; )
              n.parent._time !== n._start + (n._ts >= 0 ? n._tTime / n._ts : (n.totalDuration() - n._tTime) / -n._ts) && n.totalTime(n._tTime, !0), n = n.parent;
            !this.parent && this._dp.autoRemoveChildren && (this._ts > 0 && i < this._tDur || this._ts < 0 && i > 0 || !this._tDur && !i) && dt(this._dp, this, this._start - this._delay);
          }
          return (this._tTime !== i || !this._dur && !r || this._initted && Math.abs(this._zTime) === M || !i && !this._initted && (this.add || this._ptLookup)) && (this._ts || (this._pTime = i), Ei(this, i, r)), this;
        }, t.time = function(i, r) {
          return arguments.length ? this.totalTime(Math.min(this.totalDuration(), i + Ni(this)) % (this._dur + this._rDelay) || (i ? this._dur : 0), r) : this._time;
        }, t.totalProgress = function(i, r) {
          return arguments.length ? this.totalTime(this.totalDuration() * i, r) : this.totalDuration() ? Math.min(1, this._tTime / this._tDur) : this.rawTime() >= 0 && this._initted ? 1 : 0;
        }, t.progress = function(i, r) {
          return arguments.length ? this.totalTime(this.duration() * (this._yoyo && !(this.iteration() & 1) ? 1 - i : i) + Ni(this), r) : this.duration() ? Math.min(1, this._time / this._dur) : this.rawTime() > 0 ? 1 : 0;
        }, t.iteration = function(i, r) {
          var n = this.duration() + this._rDelay;
          return arguments.length ? this.totalTime(this._time + (i - 1) * n, r) : this._repeat ? Wt(this._tTime, n) + 1 : 1;
        }, t.timeScale = function(i, r) {
          if (!arguments.length)
            return this._rts === -M ? 0 : this._rts;
          if (this._rts === i)
            return this;
          var n = this.parent && this._ts ? Se(this.parent._time, this) : this._tTime;
          return this._rts = +i || 0, this._ts = this._ps || i === -M ? 0 : this._rts, this.totalTime(ne(-Math.abs(this._delay), this.totalDuration(), n), r !== !1), Oe(this), jr(this);
        }, t.paused = function(i) {
          return arguments.length ? (this._ps !== i && (this._ps = i, i ? (this._pTime = this._tTime || Math.max(-this._delay, this.rawTime()), this._ts = this._act = 0) : (jt(), this._ts = this._rts, this.totalTime(this.parent && !this.parent.smoothChildTiming ? this.rawTime() : this._tTime || this._pTime, this.progress() === 1 && Math.abs(this._zTime) !== M && (this._tTime -= M)))), this) : this._ps;
        }, t.startTime = function(i) {
          if (arguments.length) {
            this._start = i;
            var r = this.parent || this._dp;
            return r && (r._sort || !this.parent) && dt(r, this, i - this._delay), this;
          }
          return this._start;
        }, t.endTime = function(i) {
          return this._start + (K(i) ? this.totalDuration() : this.duration()) / Math.abs(this._ts || 1);
        }, t.rawTime = function(i) {
          var r = this.parent || this._dp;
          return r ? i && (!this._ts || this._repeat && this._time && this.totalProgress() < 1) ? this._tTime % (this._dur + this._rDelay) : this._ts ? Se(r.rawTime(i), this) : this._tTime : this._tTime;
        }, t.revert = function(i) {
          i === void 0 && (i = Gr);
          var r = G;
          return G = i, Qe(this) && (this.timeline && this.timeline.revert(i), this.totalTime(-0.01, i.suppressEvents)), this.data !== "nested" && i.kill !== !1 && this.kill(), G = r, this;
        }, t.globalTime = function(i) {
          for (var r = this, n = arguments.length ? i : r.rawTime(); r; )
            n = r._start + n / (Math.abs(r._ts) || 1), r = r._dp;
          return !this.parent && this._sat ? this._sat.globalTime(i) : n;
        }, t.repeat = function(i) {
          return arguments.length ? (this._repeat = i === 1 / 0 ? -2 : i, Yi(this)) : this._repeat === -2 ? 1 / 0 : this._repeat;
        }, t.repeatDelay = function(i) {
          if (arguments.length) {
            var r = this._time;
            return this._rDelay = i, Yi(this), r ? this.time(r) : this;
          }
          return this._rDelay;
        }, t.yoyo = function(i) {
          return arguments.length ? (this._yoyo = i, this) : this._yoyo;
        }, t.seek = function(i, r) {
          return this.totalTime(ut(this, i), K(r));
        }, t.restart = function(i, r) {
          return this.play().totalTime(i ? -this._delay : 0, K(r)), this._dur || (this._zTime = -M), this;
        }, t.play = function(i, r) {
          return i != null && this.seek(i, r), this.reversed(!1).paused(!1);
        }, t.reverse = function(i, r) {
          return i != null && this.seek(i || this.totalDuration(), r), this.reversed(!0).paused(!1);
        }, t.pause = function(i, r) {
          return i != null && this.seek(i, r), this.paused(!0);
        }, t.resume = function() {
          return this.paused(!1);
        }, t.reversed = function(i) {
          return arguments.length ? (!!i !== this.reversed() && this.timeScale(-this._rts || (i ? -M : 0)), this) : this._rts < 0;
        }, t.invalidate = function() {
          return this._initted = this._act = 0, this._zTime = -M, this;
        }, t.isActive = function() {
          var i = this.parent || this._dp, r = this._start, n;
          return !!(!i || this._ts && this._initted && i.isActive() && (n = i.rawTime(!0)) >= r && n < this.endTime(!0) - M);
        }, t.eventCallback = function(i, r, n) {
          var s = this.vars;
          return arguments.length > 1 ? (r ? (s[i] = r, n && (s[i + "Params"] = n), i === "onUpdate" && (this._onUpdate = r)) : delete s[i], this) : s[i];
        }, t.then = function(i) {
          var r = this;
          return new Promise(function(n) {
            var s = I(i) ? i : Fi, a = function() {
              var f = r.then;
              r.then = null, I(s) && (s = s(r)) && (s.then || s === r) && (r.then = f), n(s), r.then = f;
            };
            r._initted && r.totalProgress() === 1 && r._ts >= 0 || !r._tTime && r._ts < 0 ? a() : r._prom = a;
          });
        }, t.kill = function() {
          ae(this);
        }, u;
      }();
      nt(fe.prototype, {
        _time: 0,
        _start: 0,
        _end: 0,
        _tTime: 0,
        _tDur: 0,
        _dirty: 0,
        _repeat: 0,
        _yoyo: !1,
        parent: null,
        _initted: !1,
        _rDelay: 0,
        _ts: 1,
        _dp: 0,
        ratio: 0,
        _zTime: -M,
        _prom: 0,
        _ps: !1,
        _rts: 1
      });
      var W = function(u) {
        ge(t, u);
        function t(i, r) {
          var n;
          return i === void 0 && (i = {}), n = u.call(this, i) || this, n.labels = {}, n.smoothChildTiming = !!i.smoothChildTiming, n.autoRemoveChildren = !!i.autoRemoveChildren, n._sort = K(i.sortChildren), F && dt(i.parent || F, mt(n), r), i.reversed && n.reverse(), i.paused && n.paused(!0), i.scrollTrigger && Vi(mt(n), i.scrollTrigger), n;
        }
        var e = t.prototype;
        return e.to = function(r, n, s) {
          return re(0, arguments, this), this;
        }, e.from = function(r, n, s) {
          return re(1, arguments, this), this;
        }, e.fromTo = function(r, n, s, a) {
          return re(2, arguments, this), this;
        }, e.set = function(r, n, s) {
          return n.duration = 0, n.parent = this, ie(n).repeatDelay || (n.repeat = 0), n.immediateRender = !!n.immediateRender, new B(r, n, ut(this, s), 1), this;
        }, e.call = function(r, n, s) {
          return dt(this, B.delayedCall(0, r, n), s);
        }, e.staggerTo = function(r, n, s, a, o, f, h) {
          return s.duration = n, s.stagger = s.stagger || a, s.onComplete = f, s.onCompleteParams = h, s.parent = this, new B(r, s, ut(this, o)), this;
        }, e.staggerFrom = function(r, n, s, a, o, f, h) {
          return s.runBackwards = 1, ie(s).immediateRender = K(s.immediateRender), this.staggerTo(r, n, s, a, o, f, h);
        }, e.staggerFromTo = function(r, n, s, a, o, f, h, l) {
          return a.startAt = s, ie(a).immediateRender = K(a.immediateRender), this.staggerTo(r, n, a, o, f, h, l);
        }, e.render = function(r, n, s) {
          var a = this._time, o = this._dirty ? this.totalDuration() : this._tDur, f = this._dur, h = r <= 0 ? 0 : V(r), l = this._zTime < 0 != r < 0 && (this._initted || !f), c, d, p, _, m, y, v, x, T, g, b, P;
          if (this !== F && h > o && r >= 0 && (h = o), h !== this._tTime || s || l) {
            if (a !== this._time && f && (h += this._time - a, r += this._time - a), c = h, T = this._start, x = this._ts, y = !x, l && (f || (a = this._zTime), (r || !n) && (this._zTime = r)), this._repeat) {
              if (b = this._yoyo, m = f + this._rDelay, this._repeat < -1 && r < 0)
                return this.totalTime(m * 100 + r, n, s);
              if (c = V(h % m), h === o ? (_ = this._repeat, c = f) : (g = V(h / m), _ = ~~g, _ && _ === g && (c = f, _--), c > f && (c = f)), g = Wt(this._tTime, m), !a && this._tTime && g !== _ && this._tTime - g * m - this._dur <= 0 && (g = _), b && _ & 1 && (c = f - c, P = 1), _ !== g && !this._lock) {
                var S = b && g & 1, w = S === (b && _ & 1);
                if (_ < g && (S = !S), a = S ? 0 : h % f ? f : h, this._lock = 1, this.render(a || (P ? 0 : V(_ * m)), n, !f)._lock = 0, this._tTime = h, !n && this.parent && st(this, "onRepeat"), this.vars.repeatRefresh && !P && (this.invalidate()._lock = 1), a && a !== this._time || y !== !this._ts || this.vars.onRepeat && !this.parent && !this._act)
                  return this;
                if (f = this._dur, o = this._tDur, w && (this._lock = 2, a = S ? f : -1e-4, this.render(a, !0), this.vars.repeatRefresh && !P && this.invalidate()), this._lock = 0, !this._ts && !y)
                  return this;
                nr(this, P);
              }
            }
            if (this._hasPause && !this._forcing && this._lock < 2 && (v = Jr(this, V(a), V(c)), v && (h -= c - (c = v._start))), this._tTime = h, this._time = c, this._act = !x, this._initted || (this._onUpdate = this.vars.onUpdate, this._initted = 1, this._zTime = r, a = 0), !a && h && !n && !g && (st(this, "onStart"), this._tTime !== h))
              return this;
            if (c >= a && r >= 0)
              for (d = this._first; d; ) {
                if (p = d._next, (d._act || c >= d._start) && d._ts && v !== d) {
                  if (d.parent !== this)
                    return this.render(r, n, s);
                  if (d.render(d._ts > 0 ? (c - d._start) * d._ts : (d._dirty ? d.totalDuration() : d._tDur) + (c - d._start) * d._ts, n, s), c !== this._time || !this._ts && !y) {
                    v = 0, p && (h += this._zTime = -M);
                    break;
                  }
                }
                d = p;
              }
            else {
              d = this._last;
              for (var k = r < 0 ? r : c; d; ) {
                if (p = d._prev, (d._act || k <= d._end) && d._ts && v !== d) {
                  if (d.parent !== this)
                    return this.render(r, n, s);
                  if (d.render(d._ts > 0 ? (k - d._start) * d._ts : (d._dirty ? d.totalDuration() : d._tDur) + (k - d._start) * d._ts, n, s || G && Qe(d)), c !== this._time || !this._ts && !y) {
                    v = 0, p && (h += this._zTime = k ? -M : M);
                    break;
                  }
                }
                d = p;
              }
            }
            if (v && !n && (this.pause(), v.render(c >= a ? 0 : -M)._zTime = c >= a ? 1 : -1, this._ts))
              return this._start = T, Oe(this), this.render(r, n, s);
            this._onUpdate && !n && st(this, "onUpdate", !0), (h === o && this._tTime >= this.totalDuration() || !h && a) && (T === this._start || Math.abs(x) !== Math.abs(this._ts)) && (this._lock || ((r || !f) && (h === o && this._ts > 0 || !h && this._ts < 0) && wt(this, 1), !n && !(r < 0 && !a) && (h || a || !o) && (st(this, h === o && r >= 0 ? "onComplete" : "onReverseComplete", !0), this._prom && !(h < o && this.timeScale() > 0) && this._prom())));
          }
          return this;
        }, e.add = function(r, n) {
          var s = this;
          if (gt(n) || (n = ut(this, n, r)), !(r instanceof fe)) {
            if ($(r))
              return r.forEach(function(a) {
                return s.add(a, n);
              }), this;
            if (Y(r))
              return this.addLabel(r, n);
            if (I(r))
              r = B.delayedCall(0, r);
            else
              return this;
          }
          return this !== r ? dt(this, r, n) : this;
        }, e.getChildren = function(r, n, s, a) {
          r === void 0 && (r = !0), n === void 0 && (n = !0), s === void 0 && (s = !0), a === void 0 && (a = -ot);
          for (var o = [], f = this._first; f; )
            f._start >= a && (f instanceof B ? n && o.push(f) : (s && o.push(f), r && o.push.apply(o, f.getChildren(!0, n, s)))), f = f._next;
          return o;
        }, e.getById = function(r) {
          for (var n = this.getChildren(1, 1, 1), s = n.length; s--; )
            if (n[s].vars.id === r)
              return n[s];
        }, e.remove = function(r) {
          return Y(r) ? this.removeLabel(r) : I(r) ? this.killTweensOf(r) : (r.parent === this && Pe(this, r), r === this._recent && (this._recent = this._last), Dt(this));
        }, e.totalTime = function(r, n) {
          return arguments.length ? (this._forcing = 1, !this._dp && this._ts && (this._start = V(at.time - (this._ts > 0 ? r / this._ts : (this.totalDuration() - r) / -this._ts))), u.prototype.totalTime.call(this, r, n), this._forcing = 0, this) : this._tTime;
        }, e.addLabel = function(r, n) {
          return this.labels[r] = ut(this, n), this;
        }, e.removeLabel = function(r) {
          return delete this.labels[r], this;
        }, e.addPause = function(r, n, s) {
          var a = B.delayedCall(0, n || ee, s);
          return a.data = "isPause", this._hasPause = 1, dt(this, a, ut(this, r));
        }, e.removePause = function(r) {
          var n = this._first;
          for (r = ut(this, r); n; )
            n._start === r && n.data === "isPause" && wt(n), n = n._next;
        }, e.killTweensOf = function(r, n, s) {
          for (var a = this.getTweensOf(r, s), o = a.length; o--; )
            St !== a[o] && a[o].kill(r, n);
          return this;
        }, e.getTweensOf = function(r, n) {
          for (var s = [], a = ft(r), o = this._first, f = gt(n), h; o; )
            o instanceof B ? Wr(o._targets, a) && (f ? (!St || o._initted && o._ts) && o.globalTime(0) <= n && o.globalTime(o.totalDuration()) > n : !n || o.isActive()) && s.push(o) : (h = o.getTweensOf(a, n)).length && s.push.apply(s, h), o = o._next;
          return s;
        }, e.tweenTo = function(r, n) {
          n = n || {};
          var s = this, a = ut(s, r), o = n, f = o.startAt, h = o.onStart, l = o.onStartParams, c = o.immediateRender, d, p = B.to(s, nt({
            ease: n.ease || "none",
            lazy: !1,
            immediateRender: !1,
            time: a,
            overwrite: "auto",
            duration: n.duration || Math.abs((a - (f && "time" in f ? f.time : s._time)) / s.timeScale()) || M,
            onStart: function() {
              if (s.pause(), !d) {
                var m = n.duration || Math.abs((a - (f && "time" in f ? f.time : s._time)) / s.timeScale());
                p._dur !== m && Qt(p, m, 0, 1).render(p._time, !0, !0), d = 1;
              }
              h && h.apply(p, l || []);
            }
          }, n));
          return c ? p.render(0) : p;
        }, e.tweenFromTo = function(r, n, s) {
          return this.tweenTo(n, nt({
            startAt: {
              time: ut(this, r)
            }
          }, s));
        }, e.recent = function() {
          return this._recent;
        }, e.nextLabel = function(r) {
          return r === void 0 && (r = this._time), Ki(this, ut(this, r));
        }, e.previousLabel = function(r) {
          return r === void 0 && (r = this._time), Ki(this, ut(this, r), 1);
        }, e.currentLabel = function(r) {
          return arguments.length ? this.seek(r, !0) : this.previousLabel(this._time + M);
        }, e.shiftChildren = function(r, n, s) {
          s === void 0 && (s = 0);
          for (var a = this._first, o = this.labels, f; a; )
            a._start >= s && (a._start += r, a._end += r), a = a._next;
          if (n)
            for (f in o)
              o[f] >= s && (o[f] += r);
          return Dt(this);
        }, e.invalidate = function(r) {
          var n = this._first;
          for (this._lock = 0; n; )
            n.invalidate(r), n = n._next;
          return u.prototype.invalidate.call(this, r);
        }, e.clear = function(r) {
          r === void 0 && (r = !0);
          for (var n = this._first, s; n; )
            s = n._next, this.remove(n), n = s;
          return this._dp && (this._time = this._tTime = this._pTime = 0), r && (this.labels = {}), Dt(this);
        }, e.totalDuration = function(r) {
          var n = 0, s = this, a = s._last, o = ot, f, h, l;
          if (arguments.length)
            return s.timeScale((s._repeat < 0 ? s.duration() : s.totalDuration()) / (s.reversed() ? -r : r));
          if (s._dirty) {
            for (l = s.parent; a; )
              f = a._prev, a._dirty && a.totalDuration(), h = a._start, h > o && s._sort && a._ts && !s._lock ? (s._lock = 1, dt(s, a, h - a._delay, 1)._lock = 0) : o = h, h < 0 && a._ts && (n -= h, (!l && !s._dp || l && l.smoothChildTiming) && (s._start += h / s._ts, s._time -= h, s._tTime -= h), s.shiftChildren(-h, !1, -1 / 0), o = 0), a._end > n && a._ts && (n = a._end), a = f;
            Qt(s, s === F && s._time > n ? s._time : n, 1, 1), s._dirty = 0;
          }
          return s._tDur;
        }, t.updateRoot = function(r) {
          if (F._ts && (Ei(F, Se(r, F)), Di = at.frame), at.frame >= Ai) {
            Ai += et.autoSleep || 120;
            var n = F._first;
            if ((!n || !n._ts) && et.autoSleep && at._listeners.length < 2) {
              for (; n && !n._ts; )
                n = n._next;
              n || at.sleep();
            }
          }
        }, t;
      }(fe);
      nt(W.prototype, {
        _lock: 0,
        _hasPause: 0,
        _forcing: 0
      });
      var mn = function(t, e, i, r, n, s, a) {
        var o = new H(this._pt, t, e, 0, 1, lr, null, n), f = 0, h = 0, l, c, d, p, _, m, y, v;
        for (o.b = i, o.e = r, i += "", r += "", (y = ~r.indexOf("random(")) && (r = se(r)), s && (v = [i, r], s(v, t, e), i = v[0], r = v[1]), c = i.match(Ne) || []; l = Ne.exec(r); )
          p = l[0], _ = r.substring(f, l.index), d ? d = (d + 1) % 5 : _.substr(-5) === "rgba(" && (d = 1), p !== c[h++] && (m = parseFloat(c[h - 1]) || 0, o._pt = {
            _next: o._pt,
            p: _ || h === 1 ? _ : ",",
            s: m,
            c: p.charAt(1) === "=" ? qt(m, p) - m : parseFloat(p) - m,
            m: d && d < 4 ? Math.round : 0
          }, f = Ne.lastIndex);
        return o.c = f < r.length ? r.substring(f, r.length) : "", o.fp = a, (Si.test(r) || y) && (o.e = 0), this._pt = o, o;
      }, ii = function(t, e, i, r, n, s, a, o, f, h) {
        I(r) && (r = r(n || 0, t, s));
        var l = t[e], c = i !== "get" ? i : I(l) ? f ? t[e.indexOf("set") || !I(t["get" + e.substr(3)]) ? e : "get" + e.substr(3)](f) : t[e]() : l, d = I(l) ? f ? Tn : hr : si, p;
        if (Y(r) && (~r.indexOf("random(") && (r = se(r)), r.charAt(1) === "=" && (p = qt(c, r) + (j(c) || 0), (p || p === 0) && (r = p))), !h || c !== r || ri)
          return !isNaN(c * r) && r !== "" ? (p = new H(this._pt, t, e, +c || 0, r - (c || 0), typeof l == "boolean" ? bn : _r, 0, d), f && (p.fp = f), a && p.modifier(a, this, t), this._pt = p) : (!l && !(e in t) && Ue(e, r), mn.call(this, t, e, c, r, d, o || et.stringFilter, f));
      }, gn = function(t, e, i, r, n) {
        if (I(t) && (t = he(t, n, e, i, r)), !lt(t) || t.style && t.nodeType || $(t) || bi(t))
          return Y(t) ? he(t, n, e, i, r) : t;
        var s = {}, a;
        for (a in t)
          s[a] = he(t[a], n, e, i, r);
        return s;
      }, or = function(t, e, i, r, n, s) {
        var a, o, f, h;
        if (rt[t] && (a = new rt[t]()).init(n, a.rawVars ? e[t] : gn(e[t], r, n, s, i), i, r, s) !== !1 && (i._pt = o = new H(i._pt, n, t, 0, 1, a.render, a, 0, a.priority), i !== $t))
          for (f = i._ptLookup[i._targets.indexOf(n)], h = a._props.length; h--; )
            f[a._props[h]] = o;
        return a;
      }, St, ri, ni = function u(t, e, i) {
        var r = t.vars, n = r.ease, s = r.startAt, a = r.immediateRender, o = r.lazy, f = r.onUpdate, h = r.runBackwards, l = r.yoyoEase, c = r.keyframes, d = r.autoRevert, p = t._dur, _ = t._startAt, m = t._targets, y = t.parent, v = y && y.data === "nested" ? y.vars.targets : m, x = t._overwrite === "auto" && !Ee, T = t.timeline, g, b, P, S, w, k, z, A, R, Q, X, U, q;
        if (T && (!c || !n) && (n = "none"), t._ease = At(n, Yt.ease), t._yEase = l ? rr(At(l === !0 ? n : l, Yt.ease)) : 0, l && t._yoyo && !t._repeat && (l = t._yEase, t._yEase = t._ease, t._ease = l), t._from = !T && !!r.runBackwards, !T || c && !r.stagger) {
          if (A = m[0] ? Mt(m[0]).harness : 0, U = A && r[A.prop], g = be(r, Ye), _ && (_._zTime < 0 && _.progress(1), e < 0 && h && a && !d ? _.render(-1, !0) : _.revert(h && p ? xe : qr), _._lazy = 0), s) {
            if (wt(t._startAt = B.set(m, nt({
              data: "isStart",
              overwrite: !1,
              parent: y,
              immediateRender: !0,
              lazy: !_ && K(o),
              startAt: null,
              delay: 0,
              onUpdate: f && function() {
                return st(t, "onUpdate");
              },
              stagger: 0
            }, s))), t._startAt._dp = 0, t._startAt._sat = t, e < 0 && (G || !a && !d) && t._startAt.revert(xe), a && p && e <= 0 && i <= 0) {
              e && (t._zTime = e);
              return;
            }
          } else if (h && p && !_) {
            if (e && (a = !1), P = nt({
              overwrite: !1,
              data: "isFromStart",
              lazy: a && !_ && K(o),
              immediateRender: a,
              stagger: 0,
              parent: y
            }, g), U && (P[A.prop] = U), wt(t._startAt = B.set(m, P)), t._startAt._dp = 0, t._startAt._sat = t, e < 0 && (G ? t._startAt.revert(xe) : t._startAt.render(-1, !0)), t._zTime = e, !a)
              u(t._startAt, M, M);
            else if (!e)
              return;
          }
          for (t._pt = t._ptCache = 0, o = p && K(o) || o && !p, b = 0; b < m.length; b++) {
            if (w = m[b], z = w._gsap || We(m)[b]._gsap, t._ptLookup[b] = Q = {}, Xe[z.id] && Tt.length && we(), X = v === m ? b : v.indexOf(w), A && (R = new A()).init(w, U || g, t, X, v) !== !1 && (t._pt = S = new H(t._pt, w, R.name, 0, 1, R.render, R, 0, R.priority), R._props.forEach(function(_t) {
              Q[_t] = S;
            }), R.priority && (k = 1)), !A || U)
              for (P in g)
                rt[P] && (R = or(P, g, t, X, w, v)) ? R.priority && (k = 1) : Q[P] = S = ii.call(t, w, P, "get", g[P], X, v, 0, r.stringFilter);
            t._op && t._op[b] && t.kill(w, t._op[b]), x && t._pt && (St = t, F.killTweensOf(w, Q, t.globalTime(e)), q = !t.parent, St = 0), t._pt && o && (Xe[z.id] = 1);
          }
          k && cr(t), t._onInit && t._onInit(t);
        }
        t._onUpdate = f, t._initted = (!t._op || t._pt) && !q, c && e <= 0 && T.render(ot, !0, !0);
      }, yn = function(t, e, i, r, n, s, a, o) {
        var f = (t._pt && t._ptCache || (t._ptCache = {}))[e], h, l, c, d;
        if (!f)
          for (f = t._ptCache[e] = [], c = t._ptLookup, d = t._targets.length; d--; ) {
            if (h = c[d][e], h && h.d && h.d._pt)
              for (h = h.d._pt; h && h.p !== e && h.fp !== e; )
                h = h._next;
            if (!h)
              return ri = 1, t.vars[e] = "+=0", ni(t, a), ri = 0, o ? te(e + " not eligible for reset") : 1;
            f.push(h);
          }
        for (d = f.length; d--; )
          l = f[d], h = l._pt || l, h.s = (r || r === 0) && !n ? r : h.s + (r || 0) + s * h.c, h.c = i - h.s, l.e && (l.e = N(i) + j(l.e)), l.b && (l.b = h.s + j(l.b));
      }, vn = function(t, e) {
        var i = t[0] ? Mt(t[0]).harness : 0, r = i && i.aliases, n, s, a, o;
        if (!r)
          return e;
        n = Gt({}, e);
        for (s in r)
          if (s in n)
            for (o = r[s].split(","), a = o.length; a--; )
              n[o[a]] = n[s];
        return n;
      }, xn = function(t, e, i, r) {
        var n = e.ease || r || "power1.inOut", s, a;
        if ($(e))
          a = i[t] || (i[t] = []), e.forEach(function(o, f) {
            return a.push({
              t: f / (e.length - 1) * 100,
              v: o,
              e: n
            });
          });
        else
          for (s in e)
            a = i[s] || (i[s] = []), s === "ease" || a.push({
              t: parseFloat(t),
              v: e[s],
              e: n
            });
      }, he = function(t, e, i, r, n) {
        return I(t) ? t.call(e, i, r, n) : Y(t) && ~t.indexOf("random(") ? se(t) : t;
      }, ur = Ge + "repeat,repeatDelay,yoyo,repeatRefresh,yoyoEase,autoRevert", fr = {};
      Z(ur + ",id,stagger,delay,duration,paused,scrollTrigger", function(u) {
        return fr[u] = 1;
      });
      var B = function(u) {
        ge(t, u);
        function t(i, r, n, s) {
          var a;
          typeof r == "number" && (n.duration = r, r = n, n = null), a = u.call(this, s ? r : ie(r)) || this;
          var o = a.vars, f = o.duration, h = o.delay, l = o.immediateRender, c = o.stagger, d = o.overwrite, p = o.keyframes, _ = o.defaults, m = o.scrollTrigger, y = o.yoyoEase, v = r.parent || F, x = ($(i) || bi(i) ? gt(i[0]) : "length" in r) ? [i] : ft(i), T, g, b, P, S, w, k, z;
          if (a._targets = x.length ? We(x) : te("GSAP target " + i + " not found. https://gsap.com", !et.nullTargetWarn) || [], a._ptLookup = [], a._overwrite = d, p || c || ye(f) || ye(h)) {
            if (r = a.vars, T = a.timeline = new W({
              data: "nested",
              defaults: _ || {},
              targets: v && v.data === "nested" ? v.vars.targets : x
            }), T.kill(), T.parent = T._dp = mt(a), T._start = 0, c || ye(f) || ye(h)) {
              if (P = x.length, k = c && Gi(c), lt(c))
                for (S in c)
                  ~ur.indexOf(S) && (z || (z = {}), z[S] = c[S]);
              for (g = 0; g < P; g++)
                b = be(r, fr), b.stagger = 0, y && (b.yoyoEase = y), z && Gt(b, z), w = x[g], b.duration = +he(f, mt(a), g, w, x), b.delay = (+he(h, mt(a), g, w, x) || 0) - a._delay, !c && P === 1 && b.delay && (a._delay = h = b.delay, a._start += h, b.delay = 0), T.to(w, b, k ? k(g, w, x) : 0), T._ease = O.none;
              T.duration() ? f = h = 0 : a.timeline = 0;
            } else if (p) {
              ie(nt(T.vars.defaults, {
                ease: "none"
              })), T._ease = At(p.ease || r.ease || "none");
              var A = 0, R, Q, X;
              if ($(p))
                p.forEach(function(U) {
                  return T.to(x, U, ">");
                }), T.duration();
              else {
                b = {};
                for (S in p)
                  S === "ease" || S === "easeEach" || xn(S, p[S], b, p.easeEach);
                for (S in b)
                  for (R = b[S].sort(function(U, q) {
                    return U.t - q.t;
                  }), A = 0, g = 0; g < R.length; g++)
                    Q = R[g], X = {
                      ease: Q.e,
                      duration: (Q.t - (g ? R[g - 1].t : 0)) / 100 * f
                    }, X[S] = Q.v, T.to(x, X, A), A += X.duration;
                T.duration() < f && T.to({}, {
                  duration: f - T.duration()
                });
              }
            }
            f || a.duration(f = T.duration());
          } else
            a.timeline = 0;
          return d === !0 && !Ee && (St = mt(a), F.killTweensOf(x), St = 0), dt(v, mt(a), n), r.reversed && a.reverse(), r.paused && a.paused(!0), (l || !f && !p && a._start === V(v._time) && K(l) && Kr(mt(a)) && v.data !== "nested") && (a._tTime = -M, a.render(Math.max(0, -h) || 0)), m && Vi(mt(a), m), a;
        }
        var e = t.prototype;
        return e.render = function(r, n, s) {
          var a = this._time, o = this._tDur, f = this._dur, h = r < 0, l = r > o - M && !h ? o : r < M ? 0 : r, c, d, p, _, m, y, v, x, T;
          if (!f)
            Hr(this, r, n, s);
          else if (l !== this._tTime || !r || s || !this._initted && this._tTime || this._startAt && this._zTime < 0 !== h || this._lazy) {
            if (c = l, x = this.timeline, this._repeat) {
              if (_ = f + this._rDelay, this._repeat < -1 && h)
                return this.totalTime(_ * 100 + r, n, s);
              if (c = V(l % _), l === o ? (p = this._repeat, c = f) : (m = V(l / _), p = ~~m, p && p === m ? (c = f, p--) : c > f && (c = f)), y = this._yoyo && p & 1, y && (T = this._yEase, c = f - c), m = Wt(this._tTime, _), c === a && !s && this._initted && p === m)
                return this._tTime = l, this;
              p !== m && (x && this._yEase && nr(x, y), this.vars.repeatRefresh && !y && !this._lock && c !== _ && this._initted && (this._lock = s = 1, this.render(V(_ * p), !0).invalidate()._lock = 0));
            }
            if (!this._initted) {
              if (Ui(this, h ? r : c, s, n, l))
                return this._tTime = 0, this;
              if (a !== this._time && !(s && this.vars.repeatRefresh && p !== m))
                return this;
              if (f !== this._dur)
                return this.render(r, n, s);
            }
            if (this._tTime = l, this._time = c, !this._act && this._ts && (this._act = 1, this._lazy = 0), this.ratio = v = (T || this._ease)(c / f), this._from && (this.ratio = v = 1 - v), !a && l && !n && !m && (st(this, "onStart"), this._tTime !== l))
              return this;
            for (d = this._pt; d; )
              d.r(v, d.d), d = d._next;
            x && x.render(r < 0 ? r : x._dur * x._ease(c / this._dur), n, s) || this._startAt && (this._zTime = r), this._onUpdate && !n && (h && $e(this, r, n, s), st(this, "onUpdate")), this._repeat && p !== m && this.vars.onRepeat && !n && this.parent && st(this, "onRepeat"), (l === this._tDur || !l) && this._tTime === l && (h && !this._onUpdate && $e(this, r, !0, !0), (r || !f) && (l === this._tDur && this._ts > 0 || !l && this._ts < 0) && wt(this, 1), !n && !(h && !a) && (l || a || y) && (st(this, l === o ? "onComplete" : "onReverseComplete", !0), this._prom && !(l < o && this.timeScale() > 0) && this._prom()));
          }
          return this;
        }, e.targets = function() {
          return this._targets;
        }, e.invalidate = function(r) {
          return (!r || !this.vars.runBackwards) && (this._startAt = 0), this._pt = this._op = this._onUpdate = this._lazy = this.ratio = 0, this._ptLookup = [], this.timeline && this.timeline.invalidate(r), u.prototype.invalidate.call(this, r);
        }, e.resetTo = function(r, n, s, a, o) {
          ue || at.wake(), this._ts || this.play();
          var f = Math.min(this._dur, (this._dp._time - this._start) * this._ts), h;
          return this._initted || ni(this, f), h = this._ease(f / this._dur), yn(this, r, n, s, a, h, f, o) ? this.resetTo(r, n, s, a, 1) : (ke(this, 0), this.parent || Ii(this._dp, this, "_first", "_last", this._dp._sort ? "_start" : 0), this.render(0));
        }, e.kill = function(r, n) {
          if (n === void 0 && (n = "all"), !r && (!n || n === "all"))
            return this._lazy = this._pt = 0, this.parent ? ae(this) : this.scrollTrigger && this.scrollTrigger.kill(!!G), this;
          if (this.timeline) {
            var s = this.timeline.totalDuration();
            return this.timeline.killTweensOf(r, n, St && St.vars.overwrite !== !0)._first || ae(this), this.parent && s !== this.timeline.totalDuration() && Qt(this, this._dur * this.timeline._tDur / s, 0, 1), this;
          }
          var a = this._targets, o = r ? ft(r) : a, f = this._ptLookup, h = this._pt, l, c, d, p, _, m, y;
          if ((!n || n === "all") && $r(a, o))
            return n === "all" && (this._pt = 0), ae(this);
          for (l = this._op = this._op || [], n !== "all" && (Y(n) && (_ = {}, Z(n, function(v) {
            return _[v] = 1;
          }), n = _), n = vn(a, n)), y = a.length; y--; )
            if (~o.indexOf(a[y])) {
              c = f[y], n === "all" ? (l[y] = n, p = c, d = {}) : (d = l[y] = l[y] || {}, p = n);
              for (_ in p)
                m = c && c[_], m && ((!("kill" in m.d) || m.d.kill(_) === !0) && Pe(this, m, "_pt"), delete c[_]), d !== "all" && (d[_] = 1);
            }
          return this._initted && !this._pt && h && ae(this), this;
        }, t.to = function(r, n) {
          return new t(r, n, arguments[2]);
        }, t.from = function(r, n) {
          return re(1, arguments);
        }, t.delayedCall = function(r, n, s, a) {
          return new t(n, 0, {
            immediateRender: !1,
            lazy: !1,
            overwrite: !1,
            delay: r,
            onComplete: n,
            onReverseComplete: n,
            onCompleteParams: s,
            onReverseCompleteParams: s,
            callbackScope: a
          });
        }, t.fromTo = function(r, n, s) {
          return re(2, arguments);
        }, t.set = function(r, n) {
          return n.duration = 0, n.repeatDelay || (n.repeat = 0), new t(r, n);
        }, t.killTweensOf = function(r, n, s) {
          return F.killTweensOf(r, n, s);
        }, t;
      }(fe);
      nt(B.prototype, {
        _targets: [],
        _lazy: 0,
        _startAt: 0,
        _op: 0,
        _onInit: 0
      }), Z("staggerTo,staggerFrom,staggerFromTo", function(u) {
        B[u] = function() {
          var t = new W(), e = Ke.call(arguments, 0);
          return e.splice(u === "staggerFromTo" ? 5 : 4, 0, 0), t[u].apply(t, e);
        };
      });
      var si = function(t, e, i) {
        return t[e] = i;
      }, hr = function(t, e, i) {
        return t[e](i);
      }, Tn = function(t, e, i, r) {
        return t[e](r.fp, i);
      }, wn = function(t, e, i) {
        return t.setAttribute(e, i);
      }, ai = function(t, e) {
        return I(t[e]) ? hr : Fe(t[e]) && t.setAttribute ? wn : si;
      }, _r = function(t, e) {
        return e.set(e.t, e.p, Math.round((e.s + e.c * t) * 1e6) / 1e6, e);
      }, bn = function(t, e) {
        return e.set(e.t, e.p, !!(e.s + e.c * t), e);
      }, lr = function(t, e) {
        var i = e._pt, r = "";
        if (!t && e.b)
          r = e.b;
        else if (t === 1 && e.e)
          r = e.e;
        else {
          for (; i; )
            r = i.p + (i.m ? i.m(i.s + i.c * t) : Math.round((i.s + i.c * t) * 1e4) / 1e4) + r, i = i._next;
          r += e.c;
        }
        e.set(e.t, e.p, r, e);
      }, oi = function(t, e) {
        for (var i = e._pt; i; )
          i.r(t, i.d), i = i._next;
      }, Pn = function(t, e, i, r) {
        for (var n = this._pt, s; n; )
          s = n._next, n.p === r && n.modifier(t, e, i), n = s;
      }, Sn = function(t) {
        for (var e = this._pt, i, r; e; )
          r = e._next, e.p === t && !e.op || e.op === t ? Pe(this, e, "_pt") : e.dep || (i = 1), e = r;
        return !i;
      }, On = function(t, e, i, r) {
        r.mSet(t, e, r.m.call(r.tween, i, r.mt), r);
      }, cr = function(t) {
        for (var e = t._pt, i, r, n, s; e; ) {
          for (i = e._next, r = n; r && r.pr > e.pr; )
            r = r._next;
          (e._prev = r ? r._prev : s) ? e._prev._next = e : n = e, (e._next = r) ? r._prev = e : s = e, e = i;
        }
        t._pt = n;
      }, H = function() {
        function u(e, i, r, n, s, a, o, f, h) {
          this.t = i, this.s = n, this.c = s, this.p = r, this.r = a || _r, this.d = o || this, this.set = f || si, this.pr = h || 0, this._next = e, e && (e._prev = this);
        }
        var t = u.prototype;
        return t.modifier = function(i, r, n) {
          this.mSet = this.mSet || this.set, this.set = On, this.m = i, this.mt = n, this.tween = r;
        }, u;
      }();
      Z(Ge + "parent,duration,ease,delay,overwrite,runBackwards,startAt,yoyo,immediateRender,repeat,repeatDelay,data,paused,reversed,lazy,callbackScope,stringFilter,id,yoyoEase,stagger,inherit,repeatRefresh,keyframes,autoRevert,scrollTrigger", function(u) {
        return Ye[u] = 1;
      }), it.TweenMax = it.TweenLite = B, it.TimelineLite = it.TimelineMax = W, F = new W({
        sortChildren: !1,
        defaults: Yt,
        autoRemoveChildren: !0,
        id: "root",
        smoothChildTiming: !0
      }), et.stringFilter = ir;
      var Et = [], Ce = {}, kn = [], dr = 0, Cn = 0, ui = function(t) {
        return (Ce[t] || kn).map(function(e) {
          return e();
        });
      }, fi = function() {
        var t = Date.now(), e = [];
        t - dr > 2 && (ui("matchMediaInit"), Et.forEach(function(i) {
          var r = i.queries, n = i.conditions, s, a, o, f;
          for (a in r)
            s = ct.matchMedia(r[a]).matches, s && (o = 1), s !== n[a] && (n[a] = s, f = 1);
          f && (i.revert(), o && e.push(i));
        }), ui("matchMediaRevert"), e.forEach(function(i) {
          return i.onMatch(i, function(r) {
            return i.add(null, r);
          });
        }), dr = t, ui("matchMedia"));
      }, pr = function() {
        function u(e, i) {
          this.selector = i && Ze(i), this.data = [], this._r = [], this.isReverted = !1, this.id = Cn++, e && this.add(e);
        }
        var t = u.prototype;
        return t.add = function(i, r, n) {
          I(i) && (n = r, r = i, i = I);
          var s = this, a = function() {
            var f = E, h = s.selector, l;
            return f && f !== s && f.data.push(s), n && (s.selector = Ze(n)), E = s, l = r.apply(s, arguments), I(l) && s._r.push(l), E = f, s.selector = h, s.isReverted = !1, l;
          };
          return s.last = a, i === I ? a(s, function(o) {
            return s.add(null, o);
          }) : i ? s[i] = a : a;
        }, t.ignore = function(i) {
          var r = E;
          E = null, i(this), E = r;
        }, t.getTweens = function() {
          var i = [];
          return this.data.forEach(function(r) {
            return r instanceof u ? i.push.apply(i, r.getTweens()) : r instanceof B && !(r.parent && r.parent.data === "nested") && i.push(r);
          }), i;
        }, t.clear = function() {
          this._r.length = this.data.length = 0;
        }, t.kill = function(i, r) {
          var n = this;
          if (i ? function() {
            for (var a = n.getTweens(), o = n.data.length, f; o--; )
              f = n.data[o], f.data === "isFlip" && (f.revert(), f.getChildren(!0, !0, !1).forEach(function(h) {
                return a.splice(a.indexOf(h), 1);
              }));
            for (a.map(function(h) {
              return {
                g: h._dur || h._delay || h._sat && !h._sat.vars.immediateRender ? h.globalTime(0) : -1 / 0,
                t: h
              };
            }).sort(function(h, l) {
              return l.g - h.g || -1 / 0;
            }).forEach(function(h) {
              return h.t.revert(i);
            }), o = n.data.length; o--; )
              f = n.data[o], f instanceof W ? f.data !== "nested" && (f.scrollTrigger && f.scrollTrigger.revert(), f.kill()) : !(f instanceof B) && f.revert && f.revert(i);
            n._r.forEach(function(h) {
              return h(i, n);
            }), n.isReverted = !0;
          }() : this.data.forEach(function(a) {
            return a.kill && a.kill();
          }), this.clear(), r)
            for (var s = Et.length; s--; )
              Et[s].id === this.id && Et.splice(s, 1);
        }, t.revert = function(i) {
          this.kill(i || {});
        }, u;
      }(), Mn = function() {
        function u(e) {
          this.contexts = [], this.scope = e, E && E.data.push(this);
        }
        var t = u.prototype;
        return t.add = function(i, r, n) {
          lt(i) || (i = {
            matches: i
          });
          var s = new pr(0, n || this.scope), a = s.conditions = {}, o, f, h;
          E && !s.selector && (s.selector = E.selector), this.contexts.push(s), r = s.add("onMatch", r), s.queries = i;
          for (f in i)
            f === "all" ? h = 1 : (o = ct.matchMedia(i[f]), o && (Et.indexOf(s) < 0 && Et.push(s), (a[f] = o.matches) && (h = 1), o.addListener ? o.addListener(fi) : o.addEventListener("change", fi)));
          return h && r(s, function(l) {
            return s.add(null, l);
          }), this;
        }, t.revert = function(i) {
          this.kill(i || {});
        }, t.kill = function(i) {
          this.contexts.forEach(function(r) {
            return r.kill(i, !0);
          });
        }, u;
      }(), Me = {
        registerPlugin: function() {
          for (var t = arguments.length, e = new Array(t), i = 0; i < t; i++)
            e[i] = arguments[i];
          e.forEach(function(r) {
            return Hi(r);
          });
        },
        timeline: function(t) {
          return new W(t);
        },
        getTweensOf: function(t, e) {
          return F.getTweensOf(t, e);
        },
        getProperty: function(t, e, i, r) {
          Y(t) && (t = ft(t)[0]);
          var n = Mt(t || {}).get, s = i ? Fi : zi;
          return i === "native" && (i = ""), t && (e ? s((rt[e] && rt[e].get || n)(t, e, i, r)) : function(a, o, f) {
            return s((rt[a] && rt[a].get || n)(t, a, o, f));
          });
        },
        quickSetter: function(t, e, i) {
          if (t = ft(t), t.length > 1) {
            var r = t.map(function(h) {
              return J.quickSetter(h, e, i);
            }), n = r.length;
            return function(h) {
              for (var l = n; l--; )
                r[l](h);
            };
          }
          t = t[0] || {};
          var s = rt[e], a = Mt(t), o = a.harness && (a.harness.aliases || {})[e] || e, f = s ? function(h) {
            var l = new s();
            $t._pt = 0, l.init(t, i ? h + i : h, $t, 0, [t]), l.render(1, l), $t._pt && oi(1, $t);
          } : a.set(t, o);
          return s ? f : function(h) {
            return f(t, o, i ? h + i : h, a, 1);
          };
        },
        quickTo: function(t, e, i) {
          var r, n = J.to(t, nt((r = {}, r[e] = "+=0.1", r.paused = !0, r.stagger = 0, r), i || {})), s = function(o, f, h) {
            return n.resetTo(e, o, f, h);
          };
          return s.tween = n, s;
        },
        isTweening: function(t) {
          return F.getTweensOf(t, !0).length > 0;
        },
        defaults: function(t) {
          return t && t.ease && (t.ease = At(t.ease, Yt.ease)), Li(Yt, t || {});
        },
        config: function(t) {
          return Li(et, t || {});
        },
        registerEffect: function(t) {
          var e = t.name, i = t.effect, r = t.plugins, n = t.defaults, s = t.extendTimeline;
          (r || "").split(",").forEach(function(a) {
            return a && !rt[a] && !it[a] && te(e + " effect requires " + a + " plugin.");
          }), qe[e] = function(a, o, f) {
            return i(ft(a), nt(o || {}, n), f);
          }, s && (W.prototype[e] = function(a, o, f) {
            return this.add(qe[e](a, lt(o) ? o : (f = o) && {}, this), f);
          });
        },
        registerEase: function(t, e) {
          O[t] = At(e);
        },
        parseEase: function(t, e) {
          return arguments.length ? At(t, e) : O;
        },
        getById: function(t) {
          return F.getById(t);
        },
        exportRoot: function(t, e) {
          t === void 0 && (t = {});
          var i = new W(t), r, n;
          for (i.smoothChildTiming = K(t.smoothChildTiming), F.remove(i), i._dp = 0, i._time = i._tTime = F._time, r = F._first; r; )
            n = r._next, (e || !(!r._dur && r instanceof B && r.vars.onComplete === r._targets[0])) && dt(i, r, r._start - r._delay), r = n;
          return dt(F, i, 0), i;
        },
        context: function(t, e) {
          return t ? new pr(t, e) : E;
        },
        matchMedia: function(t) {
          return new Mn(t);
        },
        matchMediaRefresh: function() {
          return Et.forEach(function(t) {
            var e = t.conditions, i, r;
            for (r in e)
              e[r] && (e[r] = !1, i = 1);
            i && t.revert();
          }) || fi();
        },
        addEventListener: function(t, e) {
          var i = Ce[t] || (Ce[t] = []);
          ~i.indexOf(e) || i.push(e);
        },
        removeEventListener: function(t, e) {
          var i = Ce[t], r = i && i.indexOf(e);
          r >= 0 && i.splice(r, 1);
        },
        utils: {
          wrap: on,
          wrapYoyo: un,
          distribute: Gi,
          random: Qi,
          snap: Wi,
          normalize: an,
          getUnit: j,
          clamp: en,
          splitColor: Ji,
          toArray: ft,
          selector: Ze,
          mapRange: ji,
          pipe: nn,
          unitize: sn,
          interpolate: fn,
          shuffle: qi
        },
        install: Ci,
        effects: qe,
        ticker: at,
        updateRoot: W.updateRoot,
        plugins: rt,
        globalTimeline: F,
        core: {
          PropTween: H,
          globals: Mi,
          Tween: B,
          Timeline: W,
          Animation: fe,
          getCache: Mt,
          _removeLinkedListItem: Pe,
          reverting: function() {
            return G;
          },
          context: function(t) {
            return t && E && (E.data.push(t), t._ctx = E), E;
          },
          suppressOverwrites: function(t) {
            return Ee = t;
          }
        }
      };
      Z("to,from,fromTo,delayedCall,set,killTweensOf", function(u) {
        return Me[u] = B[u];
      }), at.add(W.updateRoot), $t = Me.to({}, {
        duration: 0
      });
      var Dn = function(t, e) {
        for (var i = t._pt; i && i.p !== e && i.op !== e && i.fp !== e; )
          i = i._next;
        return i;
      }, An = function(t, e) {
        var i = t._targets, r, n, s;
        for (r in e)
          for (n = i.length; n--; )
            s = t._ptLookup[n][r], s && (s = s.d) && (s._pt && (s = Dn(s, r)), s && s.modifier && s.modifier(e[r], t, i[n], r));
      }, hi = function(t, e) {
        return {
          name: t,
          headless: 1,
          rawVars: 1,
          init: function(r, n, s) {
            s._onInit = function(a) {
              var o, f;
              if (Y(n) && (o = {}, Z(n, function(h) {
                return o[h] = 1;
              }), n = o), e) {
                o = {};
                for (f in n)
                  o[f] = e(n[f]);
                n = o;
              }
              An(a, n);
            };
          }
        };
      }, J = Me.registerPlugin({
        name: "attr",
        init: function(t, e, i, r, n) {
          var s, a, o;
          this.tween = i;
          for (s in e)
            o = t.getAttribute(s) || "", a = this.add(t, "setAttribute", (o || 0) + "", e[s], r, n, 0, 0, s), a.op = s, a.b = o, this._props.push(s);
        },
        render: function(t, e) {
          for (var i = e._pt; i; )
            G ? i.set(i.t, i.p, i.b, i) : i.r(t, i.d), i = i._next;
        }
      }, {
        name: "endArray",
        headless: 1,
        init: function(t, e) {
          for (var i = e.length; i--; )
            this.add(t, i, t[i] || 0, e[i], 0, 0, 0, 0, 0, 1);
        }
      }, hi("roundProps", He), hi("modifiers"), hi("snap", Wi)) || Me;
      B.version = W.version = J.version = "3.13.0", ki = 1, Le() && jt();
      var Rn = O.Power0, En = O.Power1, zn = O.Power2, Fn = O.Power3, Ln = O.Power4, In = O.Linear, Nn = O.Quad, Bn = O.Cubic, Vn = O.Quart, Un = O.Quint, Yn = O.Strong, Xn = O.Elastic, qn = O.Back, Gn = O.SteppedEase, Wn = O.Bounce, Qn = O.Sine, $n = O.Expo, jn = O.Circ, mr, Ot, Kt, _i, zt, gr, li, Kn = function() {
        return typeof window < "u";
      }, yt = {}, Ft = 180 / Math.PI, Zt = Math.PI / 180, Ht = Math.atan2, yr = 1e8, ci = /([A-Z])/g, Zn = /(left|right|width|margin|padding|x)/i, Hn = /[\s,\(]\S/, pt = {
        autoAlpha: "opacity,visibility",
        scale: "scaleX,scaleY",
        alpha: "opacity"
      }, di = function(t, e) {
        return e.set(e.t, e.p, Math.round((e.s + e.c * t) * 1e4) / 1e4 + e.u, e);
      }, Jn = function(t, e) {
        return e.set(e.t, e.p, t === 1 ? e.e : Math.round((e.s + e.c * t) * 1e4) / 1e4 + e.u, e);
      }, ts = function(t, e) {
        return e.set(e.t, e.p, t ? Math.round((e.s + e.c * t) * 1e4) / 1e4 + e.u : e.b, e);
      }, es = function(t, e) {
        var i = e.s + e.c * t;
        e.set(e.t, e.p, ~~(i + (i < 0 ? -0.5 : 0.5)) + e.u, e);
      }, vr = function(t, e) {
        return e.set(e.t, e.p, t ? e.e : e.b, e);
      }, xr = function(t, e) {
        return e.set(e.t, e.p, t !== 1 ? e.b : e.e, e);
      }, is = function(t, e, i) {
        return t.style[e] = i;
      }, rs = function(t, e, i) {
        return t.style.setProperty(e, i);
      }, ns = function(t, e, i) {
        return t._gsap[e] = i;
      }, ss = function(t, e, i) {
        return t._gsap.scaleX = t._gsap.scaleY = i;
      }, as = function(t, e, i, r, n) {
        var s = t._gsap;
        s.scaleX = s.scaleY = i, s.renderTransform(n, s);
      }, os = function(t, e, i, r, n) {
        var s = t._gsap;
        s[e] = i, s.renderTransform(n, s);
      }, L = "transform", tt = L + "Origin", us = function u(t, e) {
        var i = this, r = this.target, n = r.style, s = r._gsap;
        if (t in yt && n) {
          if (this.tfm = this.tfm || {}, t !== "transform")
            t = pt[t] || t, ~t.indexOf(",") ? t.split(",").forEach(function(a) {
              return i.tfm[a] = vt(r, a);
            }) : this.tfm[t] = s.x ? s[t] : vt(r, t), t === tt && (this.tfm.zOrigin = s.zOrigin);
          else
            return pt.transform.split(",").forEach(function(a) {
              return u.call(i, a, e);
            });
          if (this.props.indexOf(L) >= 0)
            return;
          s.svg && (this.svgo = r.getAttribute("data-svg-origin"), this.props.push(tt, e, "")), t = L;
        }
        (n || e) && this.props.push(t, e, n[t]);
      }, Tr = function(t) {
        t.translate && (t.removeProperty("translate"), t.removeProperty("scale"), t.removeProperty("rotate"));
      }, fs = function() {
        var t = this.props, e = this.target, i = e.style, r = e._gsap, n, s;
        for (n = 0; n < t.length; n += 3)
          t[n + 1] ? t[n + 1] === 2 ? e[t[n]](t[n + 2]) : e[t[n]] = t[n + 2] : t[n + 2] ? i[t[n]] = t[n + 2] : i.removeProperty(t[n].substr(0, 2) === "--" ? t[n] : t[n].replace(ci, "-$1").toLowerCase());
        if (this.tfm) {
          for (s in this.tfm)
            r[s] = this.tfm[s];
          r.svg && (r.renderTransform(), e.setAttribute("data-svg-origin", this.svgo || "")), n = li(), (!n || !n.isStart) && !i[L] && (Tr(i), r.zOrigin && i[tt] && (i[tt] += " " + r.zOrigin + "px", r.zOrigin = 0, r.renderTransform()), r.uncache = 1);
        }
      }, wr = function(t, e) {
        var i = {
          target: t,
          props: [],
          revert: fs,
          save: us
        };
        return t._gsap || J.core.getCache(t), e && t.style && t.nodeType && e.split(",").forEach(function(r) {
          return i.save(r);
        }), i;
      }, br, pi = function(t, e) {
        var i = Ot.createElementNS ? Ot.createElementNS((e || "http://www.w3.org/1999/xhtml").replace(/^https/, "http"), t) : Ot.createElement(t);
        return i && i.style ? i : Ot.createElement(t);
      }, ht = function u(t, e, i) {
        var r = getComputedStyle(t);
        return r[e] || r.getPropertyValue(e.replace(ci, "-$1").toLowerCase()) || r.getPropertyValue(e) || !i && u(t, Jt(e) || e, 1) || "";
      }, Pr = "O,Moz,ms,Ms,Webkit".split(","), Jt = function(t, e, i) {
        var r = e || zt, n = r.style, s = 5;
        if (t in n && !i)
          return t;
        for (t = t.charAt(0).toUpperCase() + t.substr(1); s-- && !(Pr[s] + t in n); )
          ;
        return s < 0 ? null : (s === 3 ? "ms" : s >= 0 ? Pr[s] : "") + t;
      }, mi = function() {
        Kn() && window.document && (mr = window, Ot = mr.document, Kt = Ot.documentElement, zt = pi("div") || {
          style: {}
        }, pi("div"), L = Jt(L), tt = L + "Origin", zt.style.cssText = "border-width:0;line-height:0;position:absolute;padding:0", br = !!Jt("perspective"), li = J.core.reverting, _i = 1);
      }, Sr = function(t) {
        var e = t.ownerSVGElement, i = pi("svg", e && e.getAttribute("xmlns") || "http://www.w3.org/2000/svg"), r = t.cloneNode(!0), n;
        r.style.display = "block", i.appendChild(r), Kt.appendChild(i);
        try {
          n = r.getBBox();
        } catch {
        }
        return i.removeChild(r), Kt.removeChild(i), n;
      }, Or = function(t, e) {
        for (var i = e.length; i--; )
          if (t.hasAttribute(e[i]))
            return t.getAttribute(e[i]);
      }, kr = function(t) {
        var e, i;
        try {
          e = t.getBBox();
        } catch {
          e = Sr(t), i = 1;
        }
        return e && (e.width || e.height) || i || (e = Sr(t)), e && !e.width && !e.x && !e.y ? {
          x: +Or(t, ["x", "cx", "x1"]) || 0,
          y: +Or(t, ["y", "cy", "y1"]) || 0,
          width: 0,
          height: 0
        } : e;
      }, Cr = function(t) {
        return !!(t.getCTM && (!t.parentNode || t.ownerSVGElement) && kr(t));
      }, Lt = function(t, e) {
        if (e) {
          var i = t.style, r;
          e in yt && e !== tt && (e = L), i.removeProperty ? (r = e.substr(0, 2), (r === "ms" || e.substr(0, 6) === "webkit") && (e = "-" + e), i.removeProperty(r === "--" ? e : e.replace(ci, "-$1").toLowerCase())) : i.removeAttribute(e);
        }
      }, kt = function(t, e, i, r, n, s) {
        var a = new H(t._pt, e, i, 0, 1, s ? xr : vr);
        return t._pt = a, a.b = r, a.e = n, t._props.push(i), a;
      }, Mr = {
        deg: 1,
        rad: 1,
        turn: 1
      }, hs = {
        grid: 1,
        flex: 1
      }, Ct = function u(t, e, i, r) {
        var n = parseFloat(i) || 0, s = (i + "").trim().substr((n + "").length) || "px", a = zt.style, o = Zn.test(e), f = t.tagName.toLowerCase() === "svg", h = (f ? "client" : "offset") + (o ? "Width" : "Height"), l = 100, c = r === "px", d = r === "%", p, _, m, y;
        if (r === s || !n || Mr[r] || Mr[s])
          return n;
        if (s !== "px" && !c && (n = u(t, e, i, "px")), y = t.getCTM && Cr(t), (d || s === "%") && (yt[e] || ~e.indexOf("adius")))
          return p = y ? t.getBBox()[o ? "width" : "height"] : t[h], N(d ? n / p * l : n / 100 * p);
        if (a[o ? "width" : "height"] = l + (c ? s : r), _ = r !== "rem" && ~e.indexOf("adius") || r === "em" && t.appendChild && !f ? t : t.parentNode, y && (_ = (t.ownerSVGElement || {}).parentNode), (!_ || _ === Ot || !_.appendChild) && (_ = Ot.body), m = _._gsap, m && d && m.width && o && m.time === at.time && !m.uncache)
          return N(n / m.width * l);
        if (d && (e === "height" || e === "width")) {
          var v = t.style[e];
          t.style[e] = l + r, p = t[h], v ? t.style[e] = v : Lt(t, e);
        } else
          (d || s === "%") && !hs[ht(_, "display")] && (a.position = ht(t, "position")), _ === t && (a.position = "static"), _.appendChild(zt), p = zt[h], _.removeChild(zt), a.position = "absolute";
        return o && d && (m = Mt(_), m.time = at.time, m.width = _[h]), N(c ? p * n / l : p && n ? l / p * n : 0);
      }, vt = function(t, e, i, r) {
        var n;
        return _i || mi(), e in pt && e !== "transform" && (e = pt[e], ~e.indexOf(",") && (e = e.split(",")[0])), yt[e] && e !== "transform" ? (n = le(t, r), n = e !== "transformOrigin" ? n[e] : n.svg ? n.origin : Ae(ht(t, tt)) + " " + n.zOrigin + "px") : (n = t.style[e], (!n || n === "auto" || r || ~(n + "").indexOf("calc(")) && (n = De[e] && De[e](t, e, i) || ht(t, e) || Ri(t, e) || (e === "opacity" ? 1 : 0))), i && !~(n + "").trim().indexOf(" ") ? Ct(t, e, n, i) + i : n;
      }, _s = function(t, e, i, r) {
        if (!i || i === "none") {
          var n = Jt(e, t, 1), s = n && ht(t, n, 1);
          s && s !== i ? (e = n, i = s) : e === "borderColor" && (i = ht(t, "borderTopColor"));
        }
        var a = new H(this._pt, t.style, e, 0, 1, lr), o = 0, f = 0, h, l, c, d, p, _, m, y, v, x, T, g;
        if (a.b = i, a.e = r, i += "", r += "", r.substring(0, 6) === "var(--" && (r = ht(t, r.substring(4, r.indexOf(")")))), r === "auto" && (_ = t.style[e], t.style[e] = r, r = ht(t, e) || r, _ ? t.style[e] = _ : Lt(t, e)), h = [i, r], ir(h), i = h[0], r = h[1], c = i.match(Xt) || [], g = r.match(Xt) || [], g.length) {
          for (; l = Xt.exec(r); )
            m = l[0], v = r.substring(o, l.index), p ? p = (p + 1) % 5 : (v.substr(-5) === "rgba(" || v.substr(-5) === "hsla(") && (p = 1), m !== (_ = c[f++] || "") && (d = parseFloat(_) || 0, T = _.substr((d + "").length), m.charAt(1) === "=" && (m = qt(d, m) + T), y = parseFloat(m), x = m.substr((y + "").length), o = Xt.lastIndex - x.length, x || (x = x || et.units[e] || T, o === r.length && (r += x, a.e += x)), T !== x && (d = Ct(t, e, _, x) || 0), a._pt = {
              _next: a._pt,
              p: v || f === 1 ? v : ",",
              s: d,
              c: y - d,
              m: p && p < 4 || e === "zIndex" ? Math.round : 0
            });
          a.c = o < r.length ? r.substring(o, r.length) : "";
        } else
          a.r = e === "display" && r === "none" ? xr : vr;
        return Si.test(r) && (a.e = 0), this._pt = a, a;
      }, Dr = {
        top: "0%",
        bottom: "100%",
        left: "0%",
        right: "100%",
        center: "50%"
      }, ls = function(t) {
        var e = t.split(" "), i = e[0], r = e[1] || "50%";
        return (i === "top" || i === "bottom" || r === "left" || r === "right") && (t = i, i = r, r = t), e[0] = Dr[i] || i, e[1] = Dr[r] || r, e.join(" ");
      }, cs = function(t, e) {
        if (e.tween && e.tween._time === e.tween._dur) {
          var i = e.t, r = i.style, n = e.u, s = i._gsap, a, o, f;
          if (n === "all" || n === !0)
            r.cssText = "", o = 1;
          else
            for (n = n.split(","), f = n.length; --f > -1; )
              a = n[f], yt[a] && (o = 1, a = a === "transformOrigin" ? tt : L), Lt(i, a);
          o && (Lt(i, L), s && (s.svg && i.removeAttribute("transform"), r.scale = r.rotate = r.translate = "none", le(i, 1), s.uncache = 1, Tr(r)));
        }
      }, De = {
        clearProps: function(t, e, i, r, n) {
          if (n.data !== "isFromStart") {
            var s = t._pt = new H(t._pt, e, i, 0, 0, cs);
            return s.u = r, s.pr = -10, s.tween = n, t._props.push(i), 1;
          }
        }
      }, _e = [1, 0, 0, 1, 0, 0], Ar = {}, Rr = function(t) {
        return t === "matrix(1, 0, 0, 1, 0, 0)" || t === "none" || !t;
      }, Er = function(t) {
        var e = ht(t, L);
        return Rr(e) ? _e : e.substr(7).match(Pi).map(N);
      }, gi = function(t, e) {
        var i = t._gsap || Mt(t), r = t.style, n = Er(t), s, a, o, f;
        return i.svg && t.getAttribute("transform") ? (o = t.transform.baseVal.consolidate().matrix, n = [o.a, o.b, o.c, o.d, o.e, o.f], n.join(",") === "1,0,0,1,0,0" ? _e : n) : (n === _e && !t.offsetParent && t !== Kt && !i.svg && (o = r.display, r.display = "block", s = t.parentNode, (!s || !t.offsetParent && !t.getBoundingClientRect().width) && (f = 1, a = t.nextElementSibling, Kt.appendChild(t)), n = Er(t), o ? r.display = o : Lt(t, "display"), f && (a ? s.insertBefore(t, a) : s ? s.appendChild(t) : Kt.removeChild(t))), e && n.length > 6 ? [n[0], n[1], n[4], n[5], n[12], n[13]] : n);
      }, yi = function(t, e, i, r, n, s) {
        var a = t._gsap, o = n || gi(t, !0), f = a.xOrigin || 0, h = a.yOrigin || 0, l = a.xOffset || 0, c = a.yOffset || 0, d = o[0], p = o[1], _ = o[2], m = o[3], y = o[4], v = o[5], x = e.split(" "), T = parseFloat(x[0]) || 0, g = parseFloat(x[1]) || 0, b, P, S, w;
        i ? o !== _e && (P = d * m - p * _) && (S = T * (m / P) + g * (-_ / P) + (_ * v - m * y) / P, w = T * (-p / P) + g * (d / P) - (d * v - p * y) / P, T = S, g = w) : (b = kr(t), T = b.x + (~x[0].indexOf("%") ? T / 100 * b.width : T), g = b.y + (~(x[1] || x[0]).indexOf("%") ? g / 100 * b.height : g)), r || r !== !1 && a.smooth ? (y = T - f, v = g - h, a.xOffset = l + (y * d + v * _) - y, a.yOffset = c + (y * p + v * m) - v) : a.xOffset = a.yOffset = 0, a.xOrigin = T, a.yOrigin = g, a.smooth = !!r, a.origin = e, a.originIsAbsolute = !!i, t.style[tt] = "0px 0px", s && (kt(s, a, "xOrigin", f, T), kt(s, a, "yOrigin", h, g), kt(s, a, "xOffset", l, a.xOffset), kt(s, a, "yOffset", c, a.yOffset)), t.setAttribute("data-svg-origin", T + " " + g);
      }, le = function(t, e) {
        var i = t._gsap || new ar(t);
        if ("x" in i && !e && !i.uncache)
          return i;
        var r = t.style, n = i.scaleX < 0, s = "px", a = "deg", o = getComputedStyle(t), f = ht(t, tt) || "0", h, l, c, d, p, _, m, y, v, x, T, g, b, P, S, w, k, z, A, R, Q, X, U, q, _t, Re, de, pe, Bt, Lr, xt, Vt;
        return h = l = c = _ = m = y = v = x = T = 0, d = p = 1, i.svg = !!(t.getCTM && Cr(t)), o.translate && ((o.translate !== "none" || o.scale !== "none" || o.rotate !== "none") && (r[L] = (o.translate !== "none" ? "translate3d(" + (o.translate + " 0 0").split(" ").slice(0, 3).join(", ") + ") " : "") + (o.rotate !== "none" ? "rotate(" + o.rotate + ") " : "") + (o.scale !== "none" ? "scale(" + o.scale.split(" ").join(",") + ") " : "") + (o[L] !== "none" ? o[L] : "")), r.scale = r.rotate = r.translate = "none"), P = gi(t, i.svg), i.svg && (i.uncache ? (_t = t.getBBox(), f = i.xOrigin - _t.x + "px " + (i.yOrigin - _t.y) + "px", q = "") : q = !e && t.getAttribute("data-svg-origin"), yi(t, q || f, !!q || i.originIsAbsolute, i.smooth !== !1, P)), g = i.xOrigin || 0, b = i.yOrigin || 0, P !== _e && (z = P[0], A = P[1], R = P[2], Q = P[3], h = X = P[4], l = U = P[5], P.length === 6 ? (d = Math.sqrt(z * z + A * A), p = Math.sqrt(Q * Q + R * R), _ = z || A ? Ht(A, z) * Ft : 0, v = R || Q ? Ht(R, Q) * Ft + _ : 0, v && (p *= Math.abs(Math.cos(v * Zt))), i.svg && (h -= g - (g * z + b * R), l -= b - (g * A + b * Q))) : (Vt = P[6], Lr = P[7], de = P[8], pe = P[9], Bt = P[10], xt = P[11], h = P[12], l = P[13], c = P[14], S = Ht(Vt, Bt), m = S * Ft, S && (w = Math.cos(-S), k = Math.sin(-S), q = X * w + de * k, _t = U * w + pe * k, Re = Vt * w + Bt * k, de = X * -k + de * w, pe = U * -k + pe * w, Bt = Vt * -k + Bt * w, xt = Lr * -k + xt * w, X = q, U = _t, Vt = Re), S = Ht(-R, Bt), y = S * Ft, S && (w = Math.cos(-S), k = Math.sin(-S), q = z * w - de * k, _t = A * w - pe * k, Re = R * w - Bt * k, xt = Q * k + xt * w, z = q, A = _t, R = Re), S = Ht(A, z), _ = S * Ft, S && (w = Math.cos(S), k = Math.sin(S), q = z * w + A * k, _t = X * w + U * k, A = A * w - z * k, U = U * w - X * k, z = q, X = _t), m && Math.abs(m) + Math.abs(_) > 359.9 && (m = _ = 0, y = 180 - y), d = N(Math.sqrt(z * z + A * A + R * R)), p = N(Math.sqrt(U * U + Vt * Vt)), S = Ht(X, U), v = Math.abs(S) > 2e-4 ? S * Ft : 0, T = xt ? 1 / (xt < 0 ? -xt : xt) : 0), i.svg && (q = t.getAttribute("transform"), i.forceCSS = t.setAttribute("transform", "") || !Rr(ht(t, L)), q && t.setAttribute("transform", q))), Math.abs(v) > 90 && Math.abs(v) < 270 && (n ? (d *= -1, v += _ <= 0 ? 180 : -180, _ += _ <= 0 ? 180 : -180) : (p *= -1, v += v <= 0 ? 180 : -180)), e = e || i.uncache, i.x = h - ((i.xPercent = h && (!e && i.xPercent || (Math.round(t.offsetWidth / 2) === Math.round(-h) ? -50 : 0))) ? t.offsetWidth * i.xPercent / 100 : 0) + s, i.y = l - ((i.yPercent = l && (!e && i.yPercent || (Math.round(t.offsetHeight / 2) === Math.round(-l) ? -50 : 0))) ? t.offsetHeight * i.yPercent / 100 : 0) + s, i.z = c + s, i.scaleX = N(d), i.scaleY = N(p), i.rotation = N(_) + a, i.rotationX = N(m) + a, i.rotationY = N(y) + a, i.skewX = v + a, i.skewY = x + a, i.transformPerspective = T + s, (i.zOrigin = parseFloat(f.split(" ")[2]) || !e && i.zOrigin || 0) && (r[tt] = Ae(f)), i.xOffset = i.yOffset = 0, i.force3D = et.force3D, i.renderTransform = i.svg ? ps : br ? zr : ds, i.uncache = 0, i;
      }, Ae = function(t) {
        return (t = t.split(" "))[0] + " " + t[1];
      }, vi = function(t, e, i) {
        var r = j(e);
        return N(parseFloat(e) + parseFloat(Ct(t, "x", i + "px", r))) + r;
      }, ds = function(t, e) {
        e.z = "0px", e.rotationY = e.rotationX = "0deg", e.force3D = 0, zr(t, e);
      }, It = "0deg", ce = "0px", Nt = ") ", zr = function(t, e) {
        var i = e || this, r = i.xPercent, n = i.yPercent, s = i.x, a = i.y, o = i.z, f = i.rotation, h = i.rotationY, l = i.rotationX, c = i.skewX, d = i.skewY, p = i.scaleX, _ = i.scaleY, m = i.transformPerspective, y = i.force3D, v = i.target, x = i.zOrigin, T = "", g = y === "auto" && t && t !== 1 || y === !0;
        if (x && (l !== It || h !== It)) {
          var b = parseFloat(h) * Zt, P = Math.sin(b), S = Math.cos(b), w;
          b = parseFloat(l) * Zt, w = Math.cos(b), s = vi(v, s, P * w * -x), a = vi(v, a, -Math.sin(b) * -x), o = vi(v, o, S * w * -x + x);
        }
        m !== ce && (T += "perspective(" + m + Nt), (r || n) && (T += "translate(" + r + "%, " + n + "%) "), (g || s !== ce || a !== ce || o !== ce) && (T += o !== ce || g ? "translate3d(" + s + ", " + a + ", " + o + ") " : "translate(" + s + ", " + a + Nt), f !== It && (T += "rotate(" + f + Nt), h !== It && (T += "rotateY(" + h + Nt), l !== It && (T += "rotateX(" + l + Nt), (c !== It || d !== It) && (T += "skew(" + c + ", " + d + Nt), (p !== 1 || _ !== 1) && (T += "scale(" + p + ", " + _ + Nt), v.style[L] = T || "translate(0, 0)";
      }, ps = function(t, e) {
        var i = e || this, r = i.xPercent, n = i.yPercent, s = i.x, a = i.y, o = i.rotation, f = i.skewX, h = i.skewY, l = i.scaleX, c = i.scaleY, d = i.target, p = i.xOrigin, _ = i.yOrigin, m = i.xOffset, y = i.yOffset, v = i.forceCSS, x = parseFloat(s), T = parseFloat(a), g, b, P, S, w;
        o = parseFloat(o), f = parseFloat(f), h = parseFloat(h), h && (h = parseFloat(h), f += h, o += h), o || f ? (o *= Zt, f *= Zt, g = Math.cos(o) * l, b = Math.sin(o) * l, P = Math.sin(o - f) * -c, S = Math.cos(o - f) * c, f && (h *= Zt, w = Math.tan(f - h), w = Math.sqrt(1 + w * w), P *= w, S *= w, h && (w = Math.tan(h), w = Math.sqrt(1 + w * w), g *= w, b *= w)), g = N(g), b = N(b), P = N(P), S = N(S)) : (g = l, S = c, b = P = 0), (x && !~(s + "").indexOf("px") || T && !~(a + "").indexOf("px")) && (x = Ct(d, "x", s, "px"), T = Ct(d, "y", a, "px")), (p || _ || m || y) && (x = N(x + p - (p * g + _ * P) + m), T = N(T + _ - (p * b + _ * S) + y)), (r || n) && (w = d.getBBox(), x = N(x + r / 100 * w.width), T = N(T + n / 100 * w.height)), w = "matrix(" + g + "," + b + "," + P + "," + S + "," + x + "," + T + ")", d.setAttribute("transform", w), v && (d.style[L] = w);
      }, ms = function(t, e, i, r, n) {
        var s = 360, a = Y(n), o = parseFloat(n) * (a && ~n.indexOf("rad") ? Ft : 1), f = o - r, h = r + f + "deg", l, c;
        return a && (l = n.split("_")[1], l === "short" && (f %= s, f !== f % (s / 2) && (f += f < 0 ? s : -s)), l === "cw" && f < 0 ? f = (f + s * yr) % s - ~~(f / s) * s : l === "ccw" && f > 0 && (f = (f - s * yr) % s - ~~(f / s) * s)), t._pt = c = new H(t._pt, e, i, r, f, Jn), c.e = h, c.u = "deg", t._props.push(i), c;
      }, Fr = function(t, e) {
        for (var i in e)
          t[i] = e[i];
        return t;
      }, gs = function(t, e, i) {
        var r = Fr({}, i._gsap), n = "perspective,force3D,transformOrigin,svgOrigin", s = i.style, a, o, f, h, l, c, d, p;
        r.svg ? (f = i.getAttribute("transform"), i.setAttribute("transform", ""), s[L] = e, a = le(i, 1), Lt(i, L), i.setAttribute("transform", f)) : (f = getComputedStyle(i)[L], s[L] = e, a = le(i, 1), s[L] = f);
        for (o in yt)
          f = r[o], h = a[o], f !== h && n.indexOf(o) < 0 && (d = j(f), p = j(h), l = d !== p ? Ct(i, o, f, p) : parseFloat(f), c = parseFloat(h), t._pt = new H(t._pt, a, o, l, c - l, di), t._pt.u = p || 0, t._props.push(o));
        Fr(a, r);
      };
      Z("padding,margin,Width,Radius", function(u, t) {
        var e = "Top", i = "Right", r = "Bottom", n = "Left", s = (t < 3 ? [e, i, r, n] : [e + n, e + i, r + i, r + n]).map(function(a) {
          return t < 2 ? u + a : "border" + a + u;
        });
        De[t > 1 ? "border" + u : u] = function(a, o, f, h, l) {
          var c, d;
          if (arguments.length < 4)
            return c = s.map(function(p) {
              return vt(a, p, f);
            }), d = c.join(" "), d.split(c[0]).length === 5 ? c[0] : d;
          c = (h + "").split(" "), d = {}, s.forEach(function(p, _) {
            return d[p] = c[_] = c[_] || c[(_ - 1) / 2 | 0];
          }), a.init(o, d, l);
        };
      });
      var xi = {
        name: "css",
        register: mi,
        targetTest: function(t) {
          return t.style && t.nodeType;
        },
        init: function(t, e, i, r, n) {
          var s = this._props, a = t.style, o = i.vars.startAt, f, h, l, c, d, p, _, m, y, v, x, T, g, b, P, S;
          _i || mi(), this.styles = this.styles || wr(t), S = this.styles.props, this.tween = i;
          for (_ in e)
            if (_ !== "autoRound" && (h = e[_], !(rt[_] && or(_, e, i, r, t, n)))) {
              if (d = typeof h, p = De[_], d === "function" && (h = h.call(i, r, t, n), d = typeof h), d === "string" && ~h.indexOf("random(") && (h = se(h)), p)
                p(this, t, _, h, i) && (P = 1);
              else if (_.substr(0, 2) === "--")
                f = (getComputedStyle(t).getPropertyValue(_) + "").trim(), h += "", Pt.lastIndex = 0, Pt.test(f) || (m = j(f), y = j(h)), y ? m !== y && (f = Ct(t, _, f, y) + y) : m && (h += m), this.add(a, "setProperty", f, h, r, n, 0, 0, _), s.push(_), S.push(_, 0, a[_]);
              else if (d !== "undefined") {
                if (o && _ in o ? (f = typeof o[_] == "function" ? o[_].call(i, r, t, n) : o[_], Y(f) && ~f.indexOf("random(") && (f = se(f)), j(f + "") || f === "auto" || (f += et.units[_] || j(vt(t, _)) || ""), (f + "").charAt(1) === "=" && (f = vt(t, _))) : f = vt(t, _), c = parseFloat(f), v = d === "string" && h.charAt(1) === "=" && h.substr(0, 2), v && (h = h.substr(2)), l = parseFloat(h), _ in pt && (_ === "autoAlpha" && (c === 1 && vt(t, "visibility") === "hidden" && l && (c = 0), S.push("visibility", 0, a.visibility), kt(this, a, "visibility", c ? "inherit" : "hidden", l ? "inherit" : "hidden", !l)), _ !== "scale" && _ !== "transform" && (_ = pt[_], ~_.indexOf(",") && (_ = _.split(",")[0]))), x = _ in yt, x) {
                  if (this.styles.save(_), d === "string" && h.substring(0, 6) === "var(--" && (h = ht(t, h.substring(4, h.indexOf(")"))), l = parseFloat(h)), T || (g = t._gsap, g.renderTransform && !e.parseTransform || le(t, e.parseTransform), b = e.smoothOrigin !== !1 && g.smooth, T = this._pt = new H(this._pt, a, L, 0, 1, g.renderTransform, g, 0, -1), T.dep = 1), _ === "scale")
                    this._pt = new H(this._pt, g, "scaleY", g.scaleY, (v ? qt(g.scaleY, v + l) : l) - g.scaleY || 0, di), this._pt.u = 0, s.push("scaleY", _), _ += "X";
                  else if (_ === "transformOrigin") {
                    S.push(tt, 0, a[tt]), h = ls(h), g.svg ? yi(t, h, 0, b, 0, this) : (y = parseFloat(h.split(" ")[2]) || 0, y !== g.zOrigin && kt(this, g, "zOrigin", g.zOrigin, y), kt(this, a, _, Ae(f), Ae(h)));
                    continue;
                  } else if (_ === "svgOrigin") {
                    yi(t, h, 1, b, 0, this);
                    continue;
                  } else if (_ in Ar) {
                    ms(this, g, _, c, v ? qt(c, v + h) : h);
                    continue;
                  } else if (_ === "smoothOrigin") {
                    kt(this, g, "smooth", g.smooth, h);
                    continue;
                  } else if (_ === "force3D") {
                    g[_] = h;
                    continue;
                  } else if (_ === "transform") {
                    gs(this, h, t);
                    continue;
                  }
                } else _ in a || (_ = Jt(_) || _);
                if (x || (l || l === 0) && (c || c === 0) && !Hn.test(h) && _ in a)
                  m = (f + "").substr((c + "").length), l || (l = 0), y = j(h) || (_ in et.units ? et.units[_] : m), m !== y && (c = Ct(t, _, f, y)), this._pt = new H(this._pt, x ? g : a, _, c, (v ? qt(c, v + l) : l) - c, !x && (y === "px" || _ === "zIndex") && e.autoRound !== !1 ? es : di), this._pt.u = y || 0, m !== y && y !== "%" && (this._pt.b = f, this._pt.r = ts);
                else if (_ in a)
                  _s.call(this, t, _, f, v ? v + h : h);
                else if (_ in t)
                  this.add(t, _, f || t[_], v ? v + h : h, r, n);
                else if (_ !== "parseTransform") {
                  Ue(_, h);
                  continue;
                }
                x || (_ in a ? S.push(_, 0, a[_]) : typeof t[_] == "function" ? S.push(_, 2, t[_]()) : S.push(_, 1, f || t[_])), s.push(_);
              }
            }
          P && cr(this);
        },
        render: function(t, e) {
          if (e.tween._time || !li())
            for (var i = e._pt; i; )
              i.r(t, i.d), i = i._next;
          else
            e.styles.revert();
        },
        get: vt,
        aliases: pt,
        getSetter: function(t, e, i) {
          var r = pt[e];
          return r && r.indexOf(",") < 0 && (e = r), e in yt && e !== tt && (t._gsap.x || vt(t, "x")) ? i && gr === i ? e === "scale" ? ss : ns : (gr = i || {}) && (e === "scale" ? as : os) : t.style && !Fe(t.style[e]) ? is : ~e.indexOf("-") ? rs : ai(t, e);
        },
        core: {
          _removeProperty: Lt,
          _getMatrix: gi
        }
      };
      J.utils.checkPrefix = Jt, J.core.getStyleSaver = wr, function(u, t, e, i) {
        var r = Z(u + "," + t + "," + e, function(n) {
          yt[n] = 1;
        });
        Z(t, function(n) {
          et.units[n] = "deg", Ar[n] = 1;
        }), pt[r[13]] = u + "," + t, Z(i, function(n) {
          var s = n.split(":");
          pt[s[1]] = r[s[0]];
        });
      }("x,y,z,scale,scaleX,scaleY,xPercent,yPercent", "rotation,rotationX,rotationY,skewX,skewY", "transform,transformOrigin,svgOrigin,force3D,smoothOrigin,transformPerspective", "0:translateX,1:translateY,2:translateZ,8:rotate,8:rotationZ,8:rotateZ,9:rotateX,10:rotateY"), Z("x,y,z,top,right,bottom,left,width,height,fontSize,padding,margin,perspective", function(u) {
        et.units[u] = "px";
      }), J.registerPlugin(xi);
      var Ti = J.registerPlugin(xi) || J, ys = Ti.core.Tween;
      C.Back = qn, C.Bounce = Wn, C.CSSPlugin = xi, C.Circ = jn, C.Cubic = Bn, C.Elastic = Xn, C.Expo = $n, C.Linear = In, C.Power0 = Rn, C.Power1 = En, C.Power2 = zn, C.Power3 = Fn, C.Power4 = Ln, C.Quad = Nn, C.Quart = Vn, C.Quint = Un, C.Sine = Qn, C.SteppedEase = Gn, C.Strong = Yn, C.TimelineLite = W, C.TimelineMax = W, C.TweenLite = B, C.TweenMax = ys, C.default = Ti, C.gsap = Ti, typeof window > "u" || window !== C ? Object.defineProperty(C, "__esModule", { value: !0 }) : delete window.default;
    });
  }(me, me.exports)), me.exports;
}
var ws = Ts();
const bs = /* @__PURE__ */ vs(ws);
export {
  bs as default
};
