// ============ Salesman — shared UI parts ============
const { useState, useEffect, useRef, useContext, Fragment } = React;
const Ic = window.Icons;

// theme context — lets any screen's AppBar flip light/dark without prop threading
const ThemeCtx = React.createContext({ theme: 'light', setTheme: () => {} });
window.ThemeCtx = ThemeCtx;

// per-screen header accent gradients (also used as section color)
const ACCENT = {
  home:    'linear-gradient(135deg,#3D6BFF 0%,#6C4DF6 100%)',
  history: 'linear-gradient(135deg,#0FC2B2 0%,#0B8FA8 100%)',
  dues:    'linear-gradient(135deg,#FF8A4B 0%,#F2563E 100%)',
  customers:'linear-gradient(135deg,#3D6BFF 0%,#2546E0 100%)',
  empties: 'linear-gradient(135deg,#16C7B8 0%,#0E8FA0 100%)',
  reports: 'linear-gradient(135deg,#8E54F0 0%,#6A28D8 100%)',
  eod:     'linear-gradient(135deg,#5B6CFF 0%,#7C3AED 100%)',
  more:    'linear-gradient(135deg,#3D6BFF 0%,#6C4DF6 100%)',
  sell:    'linear-gradient(135deg,#3D6BFF 0%,#2546E0 100%)',
};
window.ACCENT = ACCENT;

// cylinder bottle badge
function Cyl({ id, size }) {
  const c = cylById(id);
  if (!c) return null;
  return (
    <span className={'cyl-ava' + (size ? ' ' + size : '')} style={{ '--cyl-c1': c.c1, '--cyl-c2': c.c2 }}>
      {c.short}
    </span>
  );
}

// payment badge
const PAY_TONE = { Cash: 'green', Due: 'red', Partial: 'orange' };
function PayPill({ pay }) {
  const map = { Cash: t('cash'), Due: t('due'), Partial: t('partial') };
  return <span className={'pill ' + (PAY_TONE[pay] || '')}>{(map[pay] || pay).toUpperCase()}</span>;
}

// colorful stat card — each metric its own color
function CStat({ color, icon, num, lbl, sub, taka }) {
  const Icon = Ic[icon];
  return (
    <div className={'cstat ' + color}>
      <span className="ico"><Icon size={17} strokeWidth={2.2} /></span>
      <div className={'num' + (taka ? ' taka' : '')}>{num}</div>
      <div className="lbl">{lbl}</div>
      {sub && <div className="sub">{sub}</div>}
    </div>
  );
}

// big hero cash card
function Hero({ icon, lbl, num, foot }) {
  const Icon = Ic[icon];
  return (
    <div className="hero">
      <div className="lbl"><Icon size={16} /> {lbl}</div>
      <div className="num taka">{num}</div>
      {foot && (
        <div className="foot">
          {foot.map((f, i) => (
            <div className="col" key={i}><div className="k">{f.k}</div><div className="v taka">{f.v}</div></div>
          ))}
        </div>
      )}
    </div>
  );
}

// tinted info banner
function Banner({ tone = 'amber', icon = 'Alert', children }) {
  const Icon = Ic[icon];
  return (
    <div className={'banner tint-' + tone}>
      <span className="ico"><Icon size={18} /></span>
      <div>{children}</div>
    </div>
  );
}

// legacy stat tile (kept for compatibility)
function StatTile({ icon, tone, num, lbl, taka }) {
  const Icon = Ic[icon];
  return (
    <div className="stat-tile">
      <span className={'ico ' + tone}><Icon size={18} /></span>
      <div className={'num' + (taka ? ' taka' : '')}>{num}</div>
      <div className="lbl">{lbl}</div>
    </div>
  );
}

// app bar — colored accent header + theme toggle + language + bell
function AppBar({ title, sub, kicker, lang, setLang, onBell, tall, curve, back, accent, children }) {
  const { theme, setTheme } = useContext(window.ThemeCtx);
  return (
    <header className={'appbar' + (tall ? ' tall' : '') + (curve ? ' curve' : '')}
      style={accent ? { background: accent } : undefined}>
      {back && (
        <div className="backbar">
          <button onClick={back}><Ic.ArrowLeft size={18} /> {t('back')}</button>
        </div>
      )}
      <div className="appbar-row">
        <div style={{ minWidth: 0 }}>
          {kicker && <div className="kicker">{kicker}</div>}
          <h1>{title}</h1>
          {sub && <p className="sub">{sub}</p>}
        </div>
        <div className="row" style={{ gap: 7 }}>
          <button className="hdr-btn ghost" onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')} aria-label="theme">
            {theme === 'dark' ? <Ic.Sun size={18} /> : <Ic.Moon size={18} />}
          </button>
          {setLang && (
            <div className="lang-toggle">
              <button className={lang === 0 ? 'on' : ''} onClick={() => setLang(0)}>EN</button>
              <button className={lang === 1 ? 'on' : ''} onClick={() => setLang(1)}>বাং</button>
            </div>
          )}
          {onBell && (
            <button className="hdr-btn" onClick={onBell}><Ic.Bell size={19} /><span className="dot"></span></button>
          )}
        </div>
      </div>
      {children}
    </header>
  );
}

// bottom nav — 5 tabs + center New Sale FAB
const TABS = [
  { id: 'home',    icon: 'Home',         key: 'dashboard' },
  { id: 'history', icon: 'ShoppingCart', key: 'history' },
  { id: 'sell',    icon: 'Plus',         key: 'sell', fab: true },
  { id: 'dues',    icon: 'Wallet',       key: 'dues' },
  { id: 'more',    icon: 'Grid',         key: 'more' },
];
function BotNav({ route, go }) {
  return (
    <nav className="botnav">
      {TABS.map((tb) => {
        const Icon = Ic[tb.icon];
        const on = route === tb.id;
        if (tb.fab) {
          return (
            <button key={tb.id} className="sell-btn" onClick={() => go('sell')}>
              <span className="sell-fab"><Ic.Plus size={26} strokeWidth={2.4} /></span>
              <span>{t('sell')}</span>
            </button>
          );
        }
        return (
          <button key={tb.id} className={on ? 'on' : ''} onClick={() => go(tb.id)}>
            <Icon size={22} strokeWidth={on ? 2.4 : 2} />
            {t(tb.key)}
          </button>
        );
      })}
    </nav>
  );
}

// toast
function Toast({ msg }) {
  if (!msg) return null;
  return (
    <div className="toast">
      <span className="ck"><Ic.Check size={16} strokeWidth={3} /></span>
      {msg}
    </div>
  );
}

Object.assign(window, { Cyl, PayPill, PAY_TONE, CStat, Hero, Banner, StatTile, AppBar, BotNav, Toast });
