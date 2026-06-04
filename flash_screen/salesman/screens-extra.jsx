// ============ Salesman — Customers · Empties · Reports ============
const { useState, useEffect, useRef, useContext, Fragment } = React;
const Ic = window.Icons;

/* ————————————————————————— CUSTOMERS ————————————————————————— */
function Customers({ go, lang, setLang, onOpen }) {
  const [q, setQ] = useState('');
  const list = CUST_LIST.filter((c) => !q || c.name.toLowerCase().includes(q.toLowerCase()) || c.phone.includes(q));
  const totalDue = CUST_LIST.reduce((s, c) => s + c.due, 0);
  return (
    <div style={{ display: 'contents' }}>
      <AppBar accent={ACCENT.customers} curve title={t('customers')} sub={CUST_LIST.length + ' · ' + ME.route} lang={lang} setLang={setLang}>
        <div className="card card-pad" style={{ marginTop: 16, background: 'rgba(255,255,255,0.14)', border: '1px solid rgba(255,255,255,0.2)', boxShadow: 'none', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ color: 'rgba(255,255,255,0.82)', fontSize: 12.5, fontWeight: 600 }}>{t('totalCustDue')}</div>
            <div className="taka" style={{ color: '#fff', fontSize: 26, fontWeight: 800, marginTop: 2 }}>{TK(totalDue)}</div>
          </div>
          <button className="btn btn-sm" style={{ background: '#fff', color: 'var(--blue-ink)' }}><Ic.UserPlus size={17} /> {t('addCustomer')}</button>
        </div>
      </AppBar>
      <div className="sm-main route-fade">
        <div className="input-icon" style={{ marginBottom: 14 }}>
          <span className="ic"><Ic.Search size={18} /></span>
          <input className="input" placeholder={t('searchName')} value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
        {list.length === 0 ? (
          <div className="empty"><span className="ico"><Ic.Users size={28} /></span><div>{t('noCustomers')}</div></div>
        ) : (
          <div className="card">
            {list.map((c, i) => (
              <button key={c.id} className="lrow" style={{ width: '100%', textAlign: 'left', ...(i ? { borderTop: '1px solid var(--line-2)' } : {}) }} onClick={() => onOpen(c)}>
                <span className="avatar" style={{ width: 44, height: 44, fontSize: 16, background: c.color }}>{c.name[0]}</span>
                <div className="grow" style={{ minWidth: 0 }}>
                  <div className="t1 ellipsis">{c.name}</div>
                  <div className="t2">{c.phone}</div>
                </div>
                <div style={{ textAlign: 'right', flex: 'none' }}>
                  {c.due > 0
                    ? <div className="taka" style={{ fontSize: 14.5, fontWeight: 800, color: 'var(--red-ink)' }}>{TK(c.due)}</div>
                    : <span className="pill green">{t('done')}</span>}
                  {c.due > 0 && <div className="tiny dim" style={{ marginTop: 2 }}>{t('pending')}</div>}
                </div>
                <Ic.ChevronRight size={18} style={{ color: 'var(--text-3)', flex: 'none' }} />
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function CustomerDetail({ cust, go, lang, setLang, onCollect }) {
  const bal = CUST_BALANCE[cust.id] || [];
  const sales = MY_SALES.filter((s) => s.customer === cust.name);
  const pendingEmpties = bal.reduce((s, b) => s + (b.sold - b.returned), 0);
  return (
    <div style={{ display: 'contents' }}>
      <AppBar accent={ACCENT.customers} title={cust.name} sub={cust.address} lang={lang} setLang={setLang} back={() => go('customers')}>
        <div className="row" style={{ gap: 10, marginTop: 16 }}>
          <a className="btn btn-sm" style={{ flex: 1, background: 'rgba(255,255,255,0.16)', color: '#fff', textDecoration: 'none' }} href={'tel:' + cust.phone}><Ic.Phone size={16} /> {t('callCustomer')}</a>
          {cust.due > 0 && <button className="btn btn-sm" style={{ flex: 1.3, background: '#fff', color: 'var(--blue-ink)' }} onClick={() => onCollect({ id: 'D-' + cust.id, customer: cust.name, cyl: bal[0]?.cyl || 'lpg12', qty: 1, due: cust.due, phone: cust.phone, age: '' })}><Ic.Wallet size={16} /> {t('collectDue')}</button>}
        </div>
      </AppBar>
      <div className="sm-main route-fade">
        {/* mini stats */}
        <div className="stat-grid" style={{ marginBottom: 18 }}>
          <CStat color={cust.due > 0 ? 'red' : 'green'} icon="CircleDollar" num={TK(cust.due)} taka lbl={t('outstanding2')} sub={cust.due > 0 ? t('pending') : t('done')} />
          <CStat color="blue" icon="BarChart" num={TK(cust.revenue)} taka lbl={t('totalRevenue')} sub={t('customer') + ' ' + cust.since} />
        </div>

        {/* cylinder balance */}
        <div className="sect-label">{t('cylBalance')}</div>
        <div className="card" style={{ marginBottom: 18 }}>
          {bal.map((b, i) => {
            const c = cylById(b.cyl);
            const pend = b.sold - b.returned;
            return (
              <div key={b.cyl} className="lrow" style={i ? { borderTop: '1px solid var(--line-2)' } : {}}>
                <Cyl id={b.cyl} size="sm" />
                <div className="grow">
                  <div className="t1" style={{ fontSize: 14 }}>{c.name}</div>
                  <div className="t2">{b.sold} {t('sold').toLowerCase()} · {b.returned} {t('returned').toLowerCase()}</div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  {pend > 0
                    ? <Fragment><div style={{ fontSize: 16, fontWeight: 800, color: 'var(--orange-ink)' }}>{pend}</div><div className="tiny dim">{t('pendingEmpties')}</div></Fragment>
                    : <span className="pill green">{t('done')}</span>}
                </div>
              </div>
            );
          })}
        </div>

        {/* recent sales */}
        <div className="sect-label">{t('recentSales2')}</div>
        <div className="card">
          {sales.length === 0
            ? <div style={{ padding: '18px 16px' }} className="tiny dim">{t('noSalesYet')}</div>
            : sales.map((s, i) => {
                const c = cylById(s.cyl);
                return (
                  <div key={s.id} className="lrow" style={i ? { borderTop: '1px solid var(--line-2)' } : {}}>
                    <Cyl id={s.cyl} size="sm" />
                    <div className="grow"><div className="t1" style={{ fontSize: 14 }}>{s.qty} × {c.size}</div><div className="t2">{s.time}</div></div>
                    <div style={{ textAlign: 'right' }}>
                      <div className="amt taka">{TK(s.qty * s.price)}</div>
                      <div style={{ marginTop: 4 }}><PayPill pay={s.pay} /></div>
                    </div>
                  </div>
                );
              })}
        </div>
      </div>
    </div>
  );
}

/* ————————————————————————— EMPTY CYLINDERS ————————————————————————— */
function Empties({ go, lang, setLang, onDone }) {
  const allocCyls = MY_ALLOC.map((a) => a.cyl);
  const [cyl, setCyl] = useState(allocCyls[0]);
  const [qty, setQty] = useState(1);
  const [mode, setMode] = useState('normal'); // normal | extra
  const [reason, setReason] = useState(EXTRA_REASONS[0][0]);
  const [cust, setCust] = useState('');
  const todayQty = EMPTIES.filter((e) => e.date.startsWith('Today')).reduce((s, e) => s + e.qty, 0);

  return (
    <div style={{ display: 'contents' }}>
      <AppBar accent={ACCENT.empties} curve title={t('emptyCyl')} sub={t('recordEmpty')} lang={lang} setLang={setLang} back={() => go('more')}>
        <div className="card card-pad" style={{ marginTop: 16, background: 'rgba(255,255,255,0.14)', border: '1px solid rgba(255,255,255,0.2)', boxShadow: 'none' }}>
          <div style={{ color: 'rgba(255,255,255,0.82)', fontSize: 12.5, fontWeight: 600 }}>{t('todaysReturns')}</div>
          <div style={{ color: '#fff', fontSize: 26, fontWeight: 800, marginTop: 2 }}>{todayQty} <span style={{ fontSize: 15, fontWeight: 600, opacity: 0.8 }}>{t('bottles')}</span></div>
        </div>
      </AppBar>
      <div className="sm-main route-fade">
        {/* mode */}
        <div className="seg plain" style={{ marginBottom: 16 }}>
          <button className={mode === 'normal' ? 'on' : ''} onClick={() => setMode('normal')}>{t('normalReturn')}</button>
          <button className={mode === 'extra' ? 'on' : ''} onClick={() => setMode('extra')}>{t('extraReturn')}</button>
        </div>

        {mode === 'extra' && (
          <div style={{ marginBottom: 16 }}>
            <Banner tone="amber" icon="Alert">{t('extraLogged')}</Banner>
          </div>
        )}

        {/* cylinder picker */}
        <div className="field">
          <span className="lbl">{t('cylinder')}</span>
          <div className="row" style={{ gap: 10, overflowX: 'auto', paddingBottom: 2 }}>
            {MY_ALLOC.map((a) => {
              const c = cylById(a.cyl);
              const on = a.cyl === cyl;
              return (
                <button key={a.cyl} onClick={() => setCyl(a.cyl)} className="card" style={{ flex: 'none', padding: '12px 14px', display: 'flex', alignItems: 'center', gap: 10, borderColor: on ? 'var(--mint)' : 'var(--line)', borderWidth: on ? 2 : 1, background: on ? 'var(--mint-bg)' : 'var(--surface)', borderStyle: 'solid' }}>
                  <Cyl id={a.cyl} size="sm" />
                  <div style={{ textAlign: 'left' }}><div style={{ fontSize: 13.5, fontWeight: 700, whiteSpace: 'nowrap' }}>{c.size}</div><div className="tiny dim" style={{ whiteSpace: 'nowrap' }}>{c.name}</div></div>
                </button>
              );
            })}
          </div>
        </div>

        {/* qty */}
        <div className="field">
          <span className="lbl">{t('emptyQty')}</span>
          <div className="card" style={{ padding: 6 }}>
            <div className="stepper">
              <button onClick={() => setQty(Math.max(1, qty - 1))}><Ic.Minus size={20} /></button>
              <div className="val">{qty}</div>
              <button onClick={() => setQty(qty + 1)}><Ic.Plus size={20} /></button>
            </div>
          </div>
        </div>

        {mode === 'extra' ? (
          <label className="field">
            <span className="lbl">{t('reason')}</span>
            <div className="input-icon">
              <span className="ic"><Ic.Sliders size={18} /></span>
              <select className="input" value={reason} onChange={(e) => setReason(e.target.value)} style={{ appearance: 'none' }}>
                {EXTRA_REASONS.map((r) => <option key={r[0]} value={r[0]}>{lang === 1 ? r[2] : r[1]}</option>)}
              </select>
              <span style={{ position: 'absolute', right: 14, top: '50%', transform: 'translateY(-50%)', color: 'var(--text-3)', pointerEvents: 'none' }}><Ic.ChevronDown size={18} /></span>
            </div>
          </label>
        ) : (
          <label className="field">
            <span className="lbl">{t('whoReturned')}</span>
            <div className="input-icon">
              <span className="ic"><Ic.Users size={18} /></span>
              <input className="input" placeholder={t('searchName')} value={cust} onChange={(e) => setCust(e.target.value)} />
            </div>
          </label>
        )}

        <button className="btn btn-green btn-block" style={{ marginTop: 4, marginBottom: 22 }} onClick={() => onDone(mode === 'extra' ? t('extraLogged') : t('emptyLogged'))}>
          <Ic.Check size={20} strokeWidth={2.6} /> {t('submitReturn')}
        </button>

        {/* today log */}
        <div className="sect-label">{t('todaysReturns')}</div>
        <div className="card">
          {EMPTIES.map((e, i) => {
            const c = cylById(e.cyl);
            return (
              <div key={e.id} className="lrow" style={i ? { borderTop: '1px solid var(--line-2)' } : {}}>
                <span className={'chip ' + (e.extra ? 'tint-amber' : 'tint-mint')} style={{ width: 40, height: 40 }}>
                  {e.extra ? <Ic.Sliders size={18} /> : <Ic.RotateCcw size={18} />}
                </span>
                <div className="grow" style={{ minWidth: 0 }}>
                  <div className="t1 ellipsis">{e.qty} × {c.size}</div>
                  <div className="t2 ellipsis">{e.customer} · {e.date}</div>
                </div>
                {e.status
                  ? <span className="pill orange">{e.status}</span>
                  : <span className="pill green"><Ic.Check size={13} strokeWidth={3} /> {t('done')}</span>}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

/* ————————————————————————— MY REPORTS ————————————————————————— */
function Reports({ go, lang, setLang }) {
  const [range, setRange] = useState('week');
  const tot = dayTotals();
  const max = Math.max(...MY_WEEK.map((d) => d.amt));
  const weekRevenue = MY_WEEK.reduce((s, d) => s + d.amt, 0);
  const pay = payBreakdown();
  const payTotal = pay.Cash + pay.Partial + pay.Due || 1;
  const segs = [
    { k: 'Cash',    v: pay.Cash,    c: '#16A34A', label: t('cash') },
    { k: 'Partial', v: pay.Partial, c: '#FF7A45', label: t('partial') },
    { k: 'Due',     v: pay.Due,     c: '#EF4444', label: t('due') },
  ];
  // build conic-gradient stops
  let acc = 0;
  const stops = segs.map((s) => {
    const start = (acc / payTotal) * 360;
    acc += s.v;
    const end = (acc / payTotal) * 360;
    return `${s.c} ${start}deg ${end}deg`;
  }).join(', ');

  const sellThrough = Math.round((tot.soldUnits / tot.allocUnits) * 100);
  const collRate = Math.round((tot.collected / (tot.collected + tot.outstanding)) * 100);

  return (
    <div style={{ display: 'contents' }}>
      <AppBar accent={ACCENT.reports} curve title={t('myReports')} sub={t('performance')} lang={lang} setLang={setLang} back={() => go('more')} />
      <div className="sm-main route-fade">
        {/* range */}
        <div className="seg plain" style={{ marginBottom: 18 }}>
          <button className={range === 'today' ? 'on' : ''} onClick={() => setRange('today')}>{t('today')}</button>
          <button className={range === 'week' ? 'on' : ''} onClick={() => setRange('week')}>{t('thisWeek')}</button>
          <button className={range === 'month' ? 'on' : ''} onClick={() => setRange('month')}>{t('thisMonth')}</button>
        </div>

        {/* KPI cards */}
        <div className="stat-grid" style={{ marginBottom: 18 }}>
          <CStat color="blue"   icon="BarChart"  num={TK(range === 'today' ? tot.revenue : weekRevenue)} taka lbl={t('revenue')} sub={range === 'week' ? t('thisWeek') : t('today')} />
          <CStat color="mint"   icon="Package"   num={range === 'today' ? tot.soldUnits : 119} lbl={t('unitsSold')} sub={t('cylinder')} />
          <CStat color="green"  icon="Wallet"    num={TK(tot.collected)} taka lbl={t('cashCollected')} sub={t('collected')} />
          <CStat color="orange" icon="Clock"     num={TK(tot.outstanding)} taka lbl={t('outstanding2')} sub={t('pending')} />
        </div>

        {/* bar chart */}
        <div className="sect-label">{t('dailyRevenue')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="bars">
            {MY_WEEK.map((d) => (
              <div key={d.d} className="bar-col">
                <div className="bar" style={{ height: Math.round((d.amt / max) * 100) + '%' }}></div>
                <div className="d">{lang === 1 ? d.d : d.d}</div>
              </div>
            ))}
          </div>
        </div>

        {/* payment donut */}
        <div className="sect-label">{t('paymentTypes')}</div>
        <div className="card card-pad" style={{ marginBottom: 18 }}>
          <div className="row" style={{ gap: 18, alignItems: 'center' }}>
            <div className="donut" style={{ background: `conic-gradient(${stops})` }}>
              <div className="hole">
                <div className="taka" style={{ fontSize: 16, fontWeight: 800 }}>{TK(payTotal)}</div>
                <div className="tiny dim">{t('total')}</div>
              </div>
            </div>
            <div className="grow" style={{ display: 'flex', flexDirection: 'column', gap: 11 }}>
              {segs.map((s) => (
                <div key={s.k} className="row" style={{ gap: 9, alignItems: 'center' }}>
                  <span className="legend-dot" style={{ background: s.c }}></span>
                  <div className="grow"><div className="t1" style={{ fontSize: 13.5 }}>{s.label}</div></div>
                  <div className="taka" style={{ fontSize: 13.5, fontWeight: 800 }}>{TK(s.v)}</div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* performance summary */}
        <div className="sect-label">{t('perfSummary')}</div>
        <div className="card" style={{ marginBottom: 18 }}>
          <MetricRow label={t('sellThrough')} val={sellThrough + '%'} pct={sellThrough} color="#2E5BFF" first />
          <MetricRow label={t('collectionRate')} val={collRate + '%'} pct={collRate} color="#16A34A" />
          <MetricRow label={t('emptiesBack2')} val={tot.emptiesBack + ' / ' + tot.soldUnits} pct={Math.round((tot.emptiesBack / tot.soldUnits) * 100)} color="#7C3AED" last />
        </div>
      </div>
    </div>
  );
}

function MetricRow({ label, val, pct, color, first, last }) {
  return (
    <div style={{ padding: '14px 16px', ...(first ? {} : { borderTop: '1px solid var(--line-2)' }) }}>
      <div className="row between" style={{ marginBottom: 8 }}>
        <span className="t1" style={{ fontSize: 14 }}>{label}</span>
        <span style={{ fontSize: 14, fontWeight: 800, color }}>{val}</span>
      </div>
      <div style={{ height: 8, borderRadius: 99, background: 'var(--line)', overflow: 'hidden' }}>
        <div style={{ height: '100%', width: Math.min(100, pct) + '%', background: color, borderRadius: 99, transition: 'width 500ms cubic-bezier(.22,.9,.3,1)' }}></div>
      </div>
    </div>
  );
}

Object.assign(window, { Customers, CustomerDetail, Empties, Reports, MetricRow });
