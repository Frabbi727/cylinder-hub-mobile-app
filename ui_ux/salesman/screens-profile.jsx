// ============ Salesman — More hub + Profile ============
const { useState, useEffect, useRef, useContext, Fragment } = React;
const Ic = window.Icons;

// —— More hub: grid of everything that doesn't fit in the bottom bar ——
function More({ go, lang, setLang, onLogout }) {
  const { theme, setTheme } = useContext(window.ThemeCtx);
  const name = lang === 1 ? ME.bnName : ME.name;
  const tot = dayTotals();

  const items = [
    { id: 'customers', icon: 'Users',     tint: 'tint-purple', label: t('customers'), sub: CUST_LIST.length + ' ' + t('customers').toLowerCase() },
    { id: 'empties',   icon: 'RotateCcw', tint: 'tint-mint',   label: t('emptyCyl'),  sub: t('todaysReturns') },
    { id: 'reports',   icon: 'BarChart',  tint: 'tint-pink',   label: t('myReports'), sub: t('performance') },
    { id: 'eod',       icon: 'Send',      tint: 'tint-amber',  label: t('endOfDay'),  sub: t('reconcileDesc') },
  ];

  return (
    <div style={{ display: 'contents' }}>
      <AppBar accent={ACCENT.more} curve title={t('more')} sub={t('manage')} lang={lang} setLang={setLang} onBell={() => {}}>
        <button onClick={() => go('profile')} className="row" style={{ gap: 13, marginTop: 16, alignItems: 'center', width: '100%', textAlign: 'left' }}>
          <span className="avatar" style={{ width: 54, height: 54, fontSize: 20, background: 'rgba(255,255,255,0.22)' }}>{ME.avatar}</span>
          <div className="grow">
            <div style={{ color: '#fff', fontSize: 18, fontWeight: 800 }}>{name}</div>
            <div style={{ color: 'rgba(255,255,255,0.82)', fontSize: 13, fontWeight: 600, marginTop: 2 }}>Salesman · {ME.route}</div>
          </div>
          <Ic.ChevronRight size={20} style={{ color: 'rgba(255,255,255,0.8)' }} />
        </button>
      </AppBar>

      <div className="sm-main route-fade">
        {/* tools */}
        <div className="sect-label">{t('quickActions')}</div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 18 }}>
          {items.map((it) => {
            const Icon = Ic[it.icon];
            return (
              <button key={it.id} className="card card-pad" onClick={() => go(it.id)} style={{ textAlign: 'left', display: 'flex', flexDirection: 'column', gap: 11 }}>
                <span className={'chip ' + it.tint} style={{ width: 44, height: 44, borderRadius: 13 }}><Icon size={22} /></span>
                <div>
                  <div className="t1" style={{ fontSize: 15 }}>{it.label}</div>
                  <div className="tiny dim" style={{ marginTop: 2 }}>{it.sub}</div>
                </div>
              </button>
            );
          })}
        </div>

        {/* appearance */}
        <div className="sect-label">{t('appearance')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="seg">
            <button className={theme === 'light' ? 'on' : ''} onClick={() => setTheme('light')}><Ic.Sun size={16} /> {t('lightMode')}</button>
            <button className={theme === 'dark' ? 'on' : ''} onClick={() => setTheme('dark')}><Ic.Moon size={16} /> {t('darkMode')}</button>
          </div>
        </div>

        {/* language */}
        <div className="sect-label">{t('language')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="seg">
            <button className={lang === 0 ? 'on' : ''} onClick={() => setLang(0)}>English</button>
            <button className={lang === 1 ? 'on' : ''} onClick={() => setLang(1)}>বাংলা</button>
          </div>
        </div>

        <button className="btn btn-block" style={{ background: 'var(--red-bg)', color: 'var(--red-ink)' }} onClick={onLogout}>
          <Ic.LogOut size={19} /> {t('logout')}
        </button>
        <div className="tiny dim" style={{ textAlign: 'center', marginTop: 16 }}>CylinderHub Salesman · v2.0</div>
      </div>
    </div>
  );
}

// —— Profile detail ——
function Profile({ lang, setLang, onLogout, go }) {
  const { theme, setTheme } = useContext(window.ThemeCtx);
  const tot = dayTotals();
  const name = lang === 1 ? ME.bnName : ME.name;
  return (
    <div style={{ display: 'contents' }}>
      <AppBar title={t('profile')} accent={ACCENT.more} lang={lang} setLang={setLang} back={() => go('more')}>
        <div className="row" style={{ gap: 14, marginTop: 14, alignItems: 'center' }}>
          <span className="avatar" style={{ width: 60, height: 60, fontSize: 22, background: 'rgba(255,255,255,0.2)' }}>{ME.avatar}</span>
          <div>
            <div style={{ color: '#fff', fontSize: 19, fontWeight: 800 }}>{name}</div>
            <div style={{ color: 'rgba(255,255,255,0.82)', fontSize: 13, fontWeight: 600, marginTop: 2 }}>Salesman · {ME.route}</div>
          </div>
        </div>
      </AppBar>
      <div className="sm-main route-fade">
        {/* today snapshot */}
        <div className="stat-grid" style={{ marginBottom: 18 }}>
          <CStat color="blue"  icon="Package" num={tot.soldUnits} lbl={t('soldToday')} />
          <CStat color="green" icon="Wallet"  num={TK(tot.collected)} taka lbl={t('collected')} />
        </div>

        <div className="sect-label">{t('account')}</div>
        <div className="card" style={{ marginBottom: 18 }}>
          <InfoRow icon="Phone" label="Phone" val={ME.phone} first />
          <InfoRow icon="Users" label="Email" val={ME.email} />
          <InfoRow icon="Truck" label="Route" val={ME.route} />
          <InfoRow icon="Calendar" label="Joined" val={ME.joined} />
        </div>

        <div className="sect-label">{t('appearance')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="seg">
            <button className={theme === 'light' ? 'on' : ''} onClick={() => setTheme('light')}><Ic.Sun size={16} /> {t('lightMode')}</button>
            <button className={theme === 'dark' ? 'on' : ''} onClick={() => setTheme('dark')}><Ic.Moon size={16} /> {t('darkMode')}</button>
          </div>
        </div>

        <div className="sect-label">{t('language')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="seg">
            <button className={lang === 0 ? 'on' : ''} onClick={() => setLang(0)}>English</button>
            <button className={lang === 1 ? 'on' : ''} onClick={() => setLang(1)}>বাংলা</button>
          </div>
        </div>

        <button className="btn btn-block" style={{ background: 'var(--red-bg)', color: 'var(--red-ink)' }} onClick={onLogout}>
          <Ic.LogOut size={19} /> {t('logout')}
        </button>
        <div className="tiny dim" style={{ textAlign: 'center', marginTop: 16 }}>CylinderHub Salesman · v2.0</div>
      </div>
    </div>
  );
}

function InfoRow({ icon, label, val, first }) {
  const Icon = Ic[icon];
  return (
    <div className="lrow" style={first ? {} : { borderTop: '1px solid var(--line-2)' }}>
      <span className="chip tint-purple" style={{ width: 38, height: 38 }}><Icon size={18} /></span>
      <div className="grow"><div className="tiny dim">{label}</div><div className="t1" style={{ fontSize: 14.5 }}>{val}</div></div>
    </div>
  );
}

Object.assign(window, { More, Profile, InfoRow });
