// ============ Pages: Login + Dashboard ============

function LoginPage({ go, lang, setLang }) {
  const [show, setShow] = useState(false);
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState('karim@cylinderhub.bd');
  const [pw, setPw] = useState('demo1234');
  const submit = (e) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => { setLoading(false); go('dashboard'); }, 700);
  };
  return (
    <div className="login-page">
      <div className="login-lang">
        <div className="lang-toggle">
          <button className={lang === 'en' ? 'on' : ''} onClick={() => setLang('en')}>EN</button>
          <button className={lang === 'bn' ? 'on' : ''} onClick={() => setLang('bn')}>BN</button>
        </div>
      </div>
      <div className="login-card">
        <div className="login-brand">
          <span className="sb-mark"><WIcons.Flame size={28} /></span>
          <div className="nm">CylinderHub</div>
          <div className="sub">{lang === 'bn' ? 'সেলসম্যান পোর্টাল' : 'Salesman Portal'}</div>
        </div>
        <form onSubmit={submit}>
          <label className="field">
            <span className="lbl">Email</span>
            <div className="input-icon-group">
              <span className="ic-left"><WIcons.Users size={16} /></span>
              <input className="input" type="email" value={email} onChange={e => setEmail(e.target.value)} required />
            </div>
          </label>
          <label className="field">
            <span className="lbl">Password</span>
            <div className="input-icon-group">
              <span className="ic-left"><WIcons.Lock size={16} /></span>
              <input className="input" type={show ? 'text' : 'password'} value={pw} onChange={e => setPw(e.target.value)} required />
              <button type="button" className="ic-right" onClick={() => setShow(s => !s)}><WIcons.Eye size={16} /></button>
            </div>
          </label>
          <label className="checkbox mb-4">
            <input type="checkbox" defaultChecked /><span className="box"><WIcons.Check size={13} /></span>
            Remember me
          </label>
          <button className="btn btn-primary btn-lg btn-block" type="submit" disabled={loading}>
            {loading ? 'Signing in…' : 'Login'}
          </button>
        </form>
      </div>
    </div>
  );
}

// ---- Allocation card (shared on dashboard) ----
function AllocationCard({ a, t, go }) {
  const c = cylById(a.cyl);
  const withYou = a.allocated - a.sold - a.returned;
  const pct = Math.round((a.sold / a.allocated) * 100);
  return (
    <div className={`alloc-card ${a.reconciled ? 'reconciled' : ''}`}>
      <div className="row between">
        <CylRow cyl={a.cyl} />
        <div className="right"><div className="cell-strong">{TKn(CYL_PRICE[a.cyl])}</div><div className="dim tiny">unit price</div></div>
      </div>
      <div className="mt-4">
        <div className="row between tiny muted mb-3"><span>{a.sold} of {a.allocated} {t('sold').toLowerCase()}</span><span>{pct}%</span></div>
        <div className="progress"><div style={{ width: pct + '%' }} /></div>
      </div>
      <div className="alloc-nums">
        <div className="n"><div className="v">{a.allocated}</div><div className="l">{t('allocated')}</div></div>
        <div className="n"><div className="v">{a.sold}</div><div className="l">{t('sold')}</div></div>
        <div className="n"><div className="v">{a.returned}</div><div className="l">{t('returned')}</div></div>
        <div className="n"><div className="v">{withYou}</div><div className="l">{t('with_you')}</div></div>
      </div>
      {a.reconciled
        ? <div className="alert-banner green" style={{ margin: 0 }}><WIcons.CheckCircle size={18} /> Reconciled</div>
        : <button className="btn btn-secondary btn-block" onClick={() => go('eod')}><WIcons.Moon size={16} /> {t('end_of_day')}</button>}
    </div>
  );
}

function Dashboard({ go, t, dashLayout, onCollect }) {
  const totalAllocated = ALLOCATIONS.reduce((a, x) => a + x.allocated, 0);
  const totalSold = ALLOCATIONS.reduce((a, x) => a + x.sold, 0);
  const todaySales = SALES.filter(s => s.dt.toDateString() === new Date('2026-06-02T12:00:00').toDateString());
  const cashToday = todaySales.reduce((a, s) => a + s.paid, 0);
  const duesTotal = SALES.filter(s => s.due > 0).reduce((a, s) => a + s.due, 0);
  const duesCount = SALES.filter(s => s.due > 0).length;
  const emptiesToday = EMPTY_RETURNS.filter(e => e.daysAgo === 0);
  const focus = dashLayout === 'focus';

  const StatsBlock = (
    <div className={focus ? '' : 'stat-grid'} style={focus ? { display: 'flex', flexDirection: 'column', gap: 14 } : {}}>
      <StatCard icon={WIcons.Package} tone="teal" label={t('total_allocated')} value={totalAllocated} delta="+8%" deltaDir="up" />
      <StatCard icon={WIcons.Receipt} tone="green" label={t('total_sold')} value={totalSold} delta="+12%" deltaDir="up" />
      <StatCard icon={WIcons.Wallet} tone="amber" label={t('cash_collected')} value={TKn(cashToday)} delta="+5%" deltaDir="up" />
      <StatCard icon={WIcons.AlertCircle} tone="red" label={t('outstanding_dues')} value={TKn(duesTotal)} delta="-3%" deltaDir="down" />
    </div>
  );

  const SalesTable = (
    <div className="card">
      <div className="card-head"><h3>{t('todays_sales')}</h3><a className="link" onClick={() => go('sales')}>{t('see_all')} <WIcons.ChevronRight size={14} /></a></div>
      {todaySales.length === 0 ? <EmptyState icon={WIcons.Receipt} title="No sales recorded yet today" /> : (
        <div className="table-wrap">
          <table className="data">
            <thead><tr><th>Time</th><th>{t('customer')}</th><th>Items</th><th className="num">{t('amount')}</th><th>Payment</th><th></th></tr></thead>
            <tbody>
              {todaySales.slice(0, 5).map(s => (
                <tr key={s.id} className="clickable" onClick={() => go('sales/' + s.id)}>
                  <td className="cell-sub">{s.time}</td>
                  <td className="cell-strong">{s.custName}</td>
                  <td className="cell-sub">{s.items.map(i => `${i.qty}× ${cylById(i.cyl).short}`).join(', ')}</td>
                  <td className="num cell-strong">{TKn(s.total)}</td>
                  <td><StatusBadge status={s.status} /></td>
                  <td className="num">{s.due > 0 && <button className="btn btn-ghost btn-sm" onClick={(e) => { e.stopPropagation(); onCollect(s); }}>{t('collect')}</button>}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );

  const SideSummary = (
    <div className="col gap-4">
      <div className="card card-pad">
        <div className="section-title">{t('outstanding_dues')}</div>
        <div className="row between"><div><div style={{ fontSize: 26, fontWeight: 750, color: 'var(--danger)' }}>{TKn(duesTotal)}</div><div className="muted tiny">{duesCount} sales unpaid</div></div>
          <button className="btn btn-secondary btn-sm" onClick={() => go('dues')}>Collect</button></div>
      </div>
      <div className="card card-pad">
        <div className="section-title">Empty Cylinders Today</div>
        {emptiesToday.length === 0 ? <div className="muted small">None collected yet.</div> :
          <div className="col gap-3">
            {Object.entries(emptiesToday.reduce((m, e) => { m[e.cyl] = (m[e.cyl] || 0) + e.qty; return m; }, {})).map(([cyl, qty]) => (
              <div key={cyl} className="row between"><div className="row gap-2"><CylAva cyl={cyl} size={30} /><span className="small">{cylById(cyl).name} {cylById(cyl).size}</span></div><span className="cell-strong">{qty}</span></div>
            ))}
          </div>}
        <button className="btn btn-ghost btn-sm mt-3" onClick={() => go('empties')}>View all <WIcons.ChevronRight size={13} /></button>
      </div>
    </div>
  );

  return (
    <div className="page">
      <div className="page-head">
        <div>
          <h1>{t('good_morning')}, {WEB_SALESMAN.name.split(' ')[0]} 👋</h1>
          <div className="sub">{t('today_overview')} — {new Date('2026-06-02').toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}</div>
        </div>
        <button className="btn btn-primary" onClick={() => go('sales/new')}><WIcons.Plus size={16} /> {t('new_sale')}</button>
      </div>

      {ALLOCATIONS.some(a => !a.reconciled) && (
        <div className="alert-banner warn"><WIcons.AlertCircle size={18} /> You have {ALLOCATIONS.filter(a => !a.reconciled).length} allocation(s) awaiting end-of-day reconciliation. Submit before 7 PM.</div>
      )}

      {focus ? (
        <div className="two-col">
          <div className="col gap-4">
            <div className="section-title">{t('todays_allocations')}</div>
            <div className="grid-2">{ALLOCATIONS.map(a => <AllocationCard key={a.id} a={a} t={t} go={go} />)}</div>
            {SalesTable}
          </div>
          <div className="col gap-4">{StatsBlock}{SideSummary}</div>
        </div>
      ) : (
        <>
          {StatsBlock}
          <div className="section-title mt-5">{t('todays_allocations')}</div>
          <div className="grid-3">{ALLOCATIONS.map(a => <AllocationCard key={a.id} a={a} t={t} go={go} />)}</div>
          <div className="two-col mt-5">{SalesTable}{SideSummary}</div>
        </>
      )}
    </div>
  );
}

Object.assign(window, { LoginPage, Dashboard, AllocationCard });
