// ============ Salesman — Login + Dashboard ============
const { useState, useEffect, useRef, useContext, Fragment } = React;
const Ic = window.Icons;

function Login({ onLogin, lang, setLang }) {
  const [email, setEmail] = useState('karim@cylinderhub.com');
  const [pw, setPw] = useState('••••••••');
  const [show, setShow] = useState(false);
  return (
    <div className="sm-root" style={{ background: 'linear-gradient(160deg,#3D6BFF 0%,#6C4DF6 100%)' }}>
      <div style={{ position: 'absolute', top: 'var(--hdr-pad-top)', right: 16, zIndex: 5 }}>
        <div className="lang-toggle">
          <button className={lang === 0 ? 'on' : ''} onClick={() => setLang(0)}>EN</button>
          <button className={lang === 1 ? 'on' : ''} onClick={() => setLang(1)}>বাং</button>
        </div>
      </div>
      <div style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', justifyContent: 'center', padding: '24px 26px 40px' }}>
        <div style={{ textAlign: 'center', marginBottom: 30 }}>
          <div style={{ width: 72, height: 72, borderRadius: 22, background: 'rgba(255,255,255,0.2)', display: 'inline-flex', alignItems: 'center', justifyContent: 'center', marginBottom: 16, boxShadow: '0 10px 24px rgba(0,0,0,0.18)' }}>
            <Ic.Flame size={38} style={{ color: '#fff' }} />
          </div>
          <div style={{ color: '#fff', fontSize: 27, fontWeight: 800, letterSpacing: '-0.02em' }}>
            Cylinder<span style={{ color: '#CFE0FF' }}>Hub</span>
          </div>
          <div style={{ color: 'rgba(255,255,255,0.82)', fontSize: 14, fontWeight: 600, marginTop: 4 }}>
            Salesman · Field App
          </div>
        </div>

        <div className="card card-pad" style={{ borderRadius: 20 }}>
          <div style={{ fontSize: 18, fontWeight: 800, marginBottom: 16, color: 'var(--text-1)' }}>{t('login')}</div>
          <label className="field">
            <span className="lbl">Email</span>
            <div className="input-icon">
              <span className="ic"><Ic.Users size={18} /></span>
              <input className="input" value={email} onChange={(e) => setEmail(e.target.value)} />
            </div>
          </label>
          <label className="field" style={{ marginBottom: 22 }}>
            <span className="lbl">{t('password')}</span>
            <div className="input-icon">
              <span className="ic"><Ic.Lock size={18} /></span>
              <input className="input" type={show ? 'text' : 'password'} value={pw} onChange={(e) => setPw(e.target.value)} style={{ paddingRight: 44 }} />
              <button onClick={() => setShow(!show)} style={{ position: 'absolute', right: 8, top: '50%', transform: 'translateY(-50%)', color: 'var(--text-3)', width: 36, height: 36, display: 'inline-flex', alignItems: 'center', justifyContent: 'center' }}>
                <Ic.Eye size={18} />
              </button>
            </div>
          </label>
          <button className="btn btn-primary btn-block" onClick={onLogin}>
            {t('login')} <Ic.ArrowRight size={18} />
          </button>
        </div>

        <div style={{ textAlign: 'center', color: 'rgba(255,255,255,0.72)', fontSize: 12.5, marginTop: 22, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
          <Ic.Shield size={14} /> Limited access · salesman role only
        </div>
      </div>
    </div>
  );
}

function MyDay({ go, lang, setLang }) {
  const tot = dayTotals();
  const firstName = (lang === 1 ? ME.bnName : ME.name).split(' ')[0];
  const hr = new Date().getHours();
  const greet = hr < 12 ? t('goodMorningG') : hr < 17 ? t('goodMorning') : t('goodEvening');
  const totalLeft = MY_ALLOC.reduce((s, a) => s + (a.alloc - a.sold), 0);

  return (
    <div style={{ display: 'contents' }}>
      <AppBar
        accent={ACCENT.home} curve
        kicker={greet}
        title={firstName}
        sub={ME.route}
        lang={lang} setLang={setLang}
        onBell={() => {}}
      >
        <div style={{ marginTop: 16 }}>
          <Hero
            icon="Wallet"
            lbl={t('cashInHand')}
            num={TK(tot.cashInHand)}
            foot={[
              { k: t('todaysProfit'), v: TK(tot.profit) },
              { k: t('cashCollected'), v: TK(tot.collected) },
            ]}
          />
        </div>
      </AppBar>

      <div className="sm-main route-fade">
        <SyncBanner />

        {/* colorful stat cards — each metric its own color */}
        <div className="stat-grid" style={{ marginTop: 14, marginBottom: 18 }}>
          <CStat color="blue"   icon="Package"   num={tot.soldUnits}  lbl={t('totalSold')}   sub={t('soldSoFar')} />
          <CStat color="mint"   icon="Box"       num={totalLeft}      lbl={t('cylindersLeft')} sub={t('canSell')} />
          <CStat color="orange" icon="Clock"     num={TK(tot.dueToday)} taka lbl={t('toCollect')} sub={MY_SALES.filter(s=>s.due>0).length + ' ' + t('salesDue')} />
          <CStat color="purple" icon="RotateCcw" num={tot.emptiesBack} lbl={t('emptiesBack')} sub={t('todaysReturns')} />
        </div>

        {/* my stock */}
        <div className="sect-label">{t('myStock')}</div>
        <div className="card" style={{ marginBottom: 18 }}>
          {MY_ALLOC.map((a, i) => {
            const c = cylById(a.cyl);
            const left = a.alloc - a.sold;
            const pct = Math.round((a.sold / a.alloc) * 100);
            return (
              <div key={a.cyl} className="lrow" style={i ? { borderTop: '1px solid var(--line-2)' } : {}}>
                <Cyl id={a.cyl} />
                <div className="grow">
                  <div className="row between" style={{ gap: 8 }}>
                    <div className="t1 ellipsis" style={{ minWidth: 0 }}>{c.name}</div>
                    <div style={{ fontSize: 14, fontWeight: 800, flex: 'none' }}>{left} <span className="dim" style={{ fontWeight: 600, fontSize: 12.5 }}>{t('left')}</span></div>
                  </div>
                  <div className="alloc-bar"><div style={{ width: pct + '%' }}></div></div>
                  <div className="tiny dim" style={{ marginTop: 5 }}>{c.size} · {a.sold} {t('sold').toLowerCase()} / {a.alloc}</div>
                </div>
              </div>
            );
          })}
        </div>

        {/* quick actions — colorful icon grid */}
        <div className="sect-label">{t('quickActions')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="qa-grid">
            <QA icon="Plus"         tint="tint-blue"   label={t('newSale')}    onClick={() => go('sell')} />
            <QA icon="Wallet"       tint="tint-green"  label={t('collect')}    onClick={() => go('dues')} />
            <QA icon="RotateCcw"    tint="tint-mint"   label={t('emptyCyl')}   onClick={() => go('empties')} />
            <QA icon="Users"        tint="tint-purple" label={t('customers')}  onClick={() => go('customers')} />
            <QA icon="BarChart"     tint="tint-pink"   label={t('myReports')}  onClick={() => go('reports')} />
            <QA icon="ShoppingCart" tint="tint-orange" label={t('history')}    onClick={() => go('history')} />
            <QA icon="Send"         tint="tint-amber"  label={t('endOfDay')}   onClick={() => go('eod')} />
            <QA icon="Grid"         tint="tint-red"    label={t('more')}       onClick={() => go('more')} />
          </div>
        </div>

        {/* recent sales */}
        <div className="sect-label">
          {t('recentSales')}
          <button className="link" onClick={() => go('history')}>{t('viewAll')} <Ic.ChevronRight size={14} /></button>
        </div>
        <div className="card">
          {MY_SALES.slice(0, 3).map((s, i) => (
            <SaleRow key={s.id} s={s} first={i === 0} />
          ))}
        </div>
      </div>
    </div>
  );
}

function QA({ icon, tint, label, onClick }) {
  const Icon = Ic[icon];
  return (
    <button className="qa" onClick={onClick}>
      <span className={'ico ' + tint}><Icon size={23} strokeWidth={2.1} /></span>
      <span className="lbl">{label}</span>
    </button>
  );
}

function SaleRow({ s, first, onClick }) {
  const c = cylById(s.cyl);
  return (
    <div className="lrow" style={first ? {} : { borderTop: '1px solid var(--line-2)' }} onClick={onClick}>
      <Cyl id={s.cyl} size="sm" />
      <div className="grow">
        <div className="t1 ellipsis">{s.customer}</div>
        <div className="t2">{s.qty} × {c.size} · {s.time}</div>
      </div>
      <div style={{ textAlign: 'right' }}>
        <div className="amt taka">{TK(s.qty * s.price)}</div>
        <div style={{ marginTop: 4 }}><PayPill pay={s.pay} /></div>
      </div>
    </div>
  );
}

function SyncBanner() {
  const online = window.__smOnline !== false;
  return (
    <div className={'sync-banner' + (online ? ' ok' : '')}>
      {online ? <Ic.Check size={14} strokeWidth={3} /> : <Ic.RefreshCw size={14} />}
      {online ? t('synced') : t('offlineQueued')}
    </div>
  );
}

Object.assign(window, { Login, MyDay, QA, SaleRow, SyncBanner });
