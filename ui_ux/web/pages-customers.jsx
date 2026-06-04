// ============ Pages: Dues + Customers + Customer Detail ============

function DuesPage({ go, t, onCollect }) {
  const [sortKey, setSortKey] = useState('days');
  const [overdueOnly, setOverdueOnly] = useState(false);
  let rows = SALES.filter(s => s.due > 0);
  if (overdueOnly) rows = rows.filter(s => s.daysOverdue > 7);
  rows = [...rows].sort((a, b) => {
    if (sortKey === 'amount') return b.due - a.due;
    if (sortKey === 'name') return (a.custName || '').localeCompare(b.custName || '');
    return b.daysOverdue - a.daysOverdue;
  });
  const total = rows.reduce((a, s) => a + s.due, 0);
  const custs = new Set(rows.map(s => s.custId)).size;
  const oldest = Math.max(0, ...rows.map(s => s.daysOverdue));
  const avg = rows.length ? Math.round(rows.reduce((a, s) => a + s.daysOverdue, 0) / rows.length) : 0;
  const ageClass = (d) => d > 7 ? 'txt-red' : d >= 3 ? 'txt-amber' : 'txt-green';

  return (
    <div className="page">
      <div className="page-head">
        <div><h1>{t('outstanding_dues')}</h1><div style={{ fontSize: 26, fontWeight: 750, color: 'var(--danger)', marginTop: 4 }}>{TKn(total)}</div></div>
        <button className="btn btn-grey"><WIcons.Download size={16} /> {t('export_csv')}</button>
      </div>

      <div className="stat-grid mb-4">
        <StatCard icon={WIcons.AlertCircle} tone="red" label="Total Due Amount" value={TKn(total)} />
        <StatCard icon={WIcons.Users} tone="teal" label="Customers" value={custs} />
        <StatCard icon={WIcons.Clock} tone="amber" label="Oldest Due" value={oldest + ' days'} />
        <StatCard icon={WIcons.Gauge} tone="purple" label="Average Due Age" value={avg + ' days'} />
      </div>

      <div className="filter-bar">
        <label className="checkbox"><input type="checkbox" checked={overdueOnly} onChange={e => setOverdueOnly(e.target.checked)} /><span className="box"><WIcons.Check size={13} /></span> Show only overdue &gt; 7 days</label>
        <div className="mla row gap-2">
          <span className="muted small">Sort by</span>
          <select className="select" style={{ width: 150 }} value={sortKey} onChange={e => setSortKey(e.target.value)}>
            <option value="amount">Amount</option><option value="days">Days Overdue</option><option value="name">Customer name</option>
          </select>
        </div>
      </div>

      <div className="card">
        {rows.length === 0 ? <EmptyState good icon={WIcons.CheckCircle} title="All dues collected!" sub="Great work — nothing outstanding." /> : (
          <div className="table-wrap"><table className="data">
            <thead><tr><th>{t('customer')}</th><th>Phone</th><th>Sale Date</th><th className="num">Days Overdue</th><th className="num">Total</th><th className="num">{t('paid')}</th><th className="num">Remaining</th><th></th></tr></thead>
            <tbody>{rows.map(s => {
              const c = customerById(s.custId);
              return (
                <tr key={s.id} className={s.daysOverdue > 7 ? 'danger-row' : ''}>
                  <td className="cell-strong clickable" onClick={() => c && go('customers/' + c.id)}>{s.custName}</td>
                  <td className="cell-sub">{c ? c.phone : '—'}</td>
                  <td className="cell-sub">{fmtShortDate(s.dt)}</td>
                  <td className={`num ${ageClass(s.daysOverdue)}`}>{s.daysOverdue}d</td>
                  <td className="num">{TKn(s.total)}</td>
                  <td className="num txt-green">{TKn(s.paid)}</td>
                  <td className="num txt-red" style={{ fontWeight: 700 }}>{TKn(s.due)}</td>
                  <td className="num"><button className="btn btn-secondary btn-sm" onClick={() => onCollect(s)}><WIcons.Wallet size={14} /> {t('collect')}</button></td>
                </tr>
              );
            })}</tbody>
          </table></div>
        )}
      </div>
    </div>
  );
}

function CustomersPage({ go, t }) {
  const toast = useToast();
  const [q, setQ] = useState('');
  const [duesOnly, setDuesOnly] = useState(false);
  const [showAdd, setShowAdd] = useState(false);
  const [nc, setNc] = useState({ name: '', phone: '', address: '' });
  let rows = CUSTOMERS.map(c => ({ ...c, ...customerStats(c.id) }));
  if (q) rows = rows.filter(c => c.name.toLowerCase().includes(q.toLowerCase()) || c.phone.includes(q));
  if (duesOnly) rows = rows.filter(c => c.totalDue > 0);

  return (
    <div className="page">
      <div className="page-head">
        <div><h1>{t('nav_customers')}</h1><div className="sub">{rows.length} customers</div></div>
        <button className="btn btn-primary" onClick={() => setShowAdd(true)}><WIcons.Plus size={16} /> {t('add_customer')}</button>
      </div>
      <div className="filter-bar">
        <div className="search-box"><span className="ic"><WIcons.Search size={15} /></span><input placeholder="Search name or phone…" value={q} onChange={e => setQ(e.target.value)} /></div>
        <label className="checkbox"><input type="checkbox" checked={duesOnly} onChange={e => setDuesOnly(e.target.checked)} /><span className="box"><WIcons.Check size={13} /></span> Only with outstanding dues</label>
      </div>
      <div className="card">
        <div className="table-wrap"><table className="data">
          <thead><tr><th>Customer Name</th><th>Phone</th><th className="num">Sales</th><th className="num">Total Due</th><th className="num">Empties Owed</th><th>Last Sale</th><th></th></tr></thead>
          <tbody>{rows.map(c => (
            <tr key={c.id} className={`clickable ${c.totalDue > 0 ? 'danger-row' : ''}`} onClick={() => go('customers/' + c.id)}>
              <td className="cell-strong">{c.name}</td>
              <td className="cell-sub">{c.phone}</td>
              <td className="num">{c.totalSales}</td>
              <td className="num">{c.totalDue > 0 ? <span className="txt-red">{TKn(c.totalDue)}</span> : '—'}</td>
              <td className="num">{c.emptiesOwed > 0 ? <span className="txt-amber"><WIcons.Package size={13} style={{ verticalAlign: 'middle' }} /> {c.emptiesOwed}</span> : '—'}</td>
              <td className="cell-sub">{c.lastSale ? fmtShortDate(c.lastSale) : '—'}</td>
              <td className="num"><button className="btn btn-ghost btn-sm" onClick={(e) => { e.stopPropagation(); go('customers/' + c.id); }}>{t('view')}</button></td>
            </tr>
          ))}</tbody>
        </table></div>
      </div>
      {showAdd && (
        <Modal title="Add New Customer" onClose={() => setShowAdd(false)}
          footer={<><button className="btn btn-grey" onClick={() => setShowAdd(false)}>Cancel</button>
            <button className="btn btn-primary" disabled={!nc.name || !nc.phone} onClick={() => { setShowAdd(false); toast('Customer added'); }}>Add Customer</button></>}>
          <label className="field"><span className="lbl">Name <span className="req">*</span></span><input className="input" value={nc.name} onChange={e => setNc(s => ({ ...s, name: e.target.value }))} /></label>
          <label className="field"><span className="lbl">Phone <span className="req">*</span></span><input className="input" value={nc.phone} onChange={e => setNc(s => ({ ...s, phone: e.target.value }))} /></label>
          <label className="field" style={{ marginBottom: 0 }}><span className="lbl">Address (optional)</span><input className="input" value={nc.address} onChange={e => setNc(s => ({ ...s, address: e.target.value }))} /></label>
        </Modal>
      )}
    </div>
  );
}

function CustomerDetailPage({ id, go, t, onCollect }) {
  const c = customerById(id);
  const [tab, setTab] = useState('sales');
  if (!c) return <div className="page"><EmptyState icon={WIcons.AlertCircle} title="Customer not found" /></div>;
  const stats = customerStats(id);
  const sales = SALES.filter(s => s.custId === id);
  const payments = sales.flatMap(s => s.payments.map(p => ({ ...p, saleId: s.id })));
  // empties per type
  const emptyByType = {};
  sales.forEach(s => s.items.forEach(it => { emptyByType[it.cyl] = emptyByType[it.cyl] || { sold: 0, returned: 0 }; emptyByType[it.cyl].sold += it.qty; }));
  EMPTY_RETURNS.filter(e => e.custId === id).forEach(e => { emptyByType[e.cyl] = emptyByType[e.cyl] || { sold: 0, returned: 0 }; emptyByType[e.cyl].returned += e.qty; });

  return (
    <div className="page">
      <button className="btn btn-ghost btn-sm mb-3" onClick={() => go('customers')}><WIcons.ArrowLeft size={16} /> Back to Customers</button>
      <div className="two-col">
        <div className="col gap-4">
          <div className="card card-pad">
            <div className="row between">
              <div className="row gap-3">
                <span className="sb-avatar" style={{ width: 52, height: 52, fontSize: 18, background: 'linear-gradient(135deg,#2BB3C0,#0E7B86)' }}>{c.name.split(' ').map(x => x[0]).slice(0, 2).join('')}</span>
                <div>
                  <h1 style={{ fontSize: 21 }}>{c.name}</h1>
                  <div className="sub row gap-3 wrap"><span><WIcons.PhoneIcon size={13} style={{ verticalAlign: 'middle' }} /> {c.phone}</span><span><WIcons.MapPin size={13} style={{ verticalAlign: 'middle' }} /> {c.address}</span></div>
                </div>
              </div>
              <button className="btn btn-grey btn-sm"><WIcons.Settings size={15} /> Edit</button>
            </div>
            <div className="row gap-4 mt-4 wrap">
              {stats.totalDue > 0 && <span className="badge badge-soft-red" style={{ fontSize: 13, padding: '6px 12px' }}>Due {TKn(stats.totalDue)}</span>}
              {stats.emptiesOwed > 0 && <span className="badge badge-soft-amber" style={{ fontSize: 13, padding: '6px 12px' }}><WIcons.Package size={13} /> {stats.emptiesOwed} empties owed</span>}
            </div>
          </div>

          <div className="card card-pad">
            <div className="tabs-nav">
              {[['sales', 'Sales History'], ['payments', 'Payment History'], ['empties', 'Empty Cylinders'], ['notes', 'Notes']].map(([k, l]) => (
                <button key={k} className={tab === k ? 'on' : ''} onClick={() => setTab(k)}>{l}</button>
              ))}
            </div>
            {tab === 'sales' && (
              <div className="table-wrap"><table className="data">
                <thead><tr><th>Date</th><th>Items</th><th className="num">Amount</th><th className="num">Due</th><th>Status</th><th></th></tr></thead>
                <tbody>{sales.map(s => (
                  <tr key={s.id} className="clickable" onClick={() => go('sales/' + s.id)}>
                    <td>{fmtShortDate(s.dt)}</td><td className="cell-sub">{s.items.map(i => `${i.qty}× ${cylById(i.cyl).short}`).join(', ')}</td>
                    <td className="num cell-strong">{TKn(s.total)}</td><td className="num">{s.due > 0 ? <span className="txt-red">{TKn(s.due)}</span> : '—'}</td>
                    <td><StatusBadge status={s.status} /></td>
                    <td className="num">{s.due > 0 && <button className="btn btn-ghost btn-sm" onClick={(e) => { e.stopPropagation(); onCollect(s); }}>{t('collect')}</button>}</td>
                  </tr>
                ))}</tbody>
              </table></div>
            )}
            {tab === 'payments' && (
              payments.length ? <div className="table-wrap"><table className="data">
                <thead><tr><th>Date</th><th>Sale</th><th className="num">Amount</th><th>Note</th></tr></thead>
                <tbody>{payments.map((p, i) => <tr key={i}><td>{p.date}</td><td className="clickable" onClick={() => go('sales/' + p.saleId)}>#{p.saleId}</td><td className="num txt-green">{TKn(p.amount)}</td><td className="cell-sub">{p.note}</td></tr>)}</tbody>
              </table></div> : <EmptyState icon={WIcons.Wallet} title="No payments recorded" />
            )}
            {tab === 'empties' && (
              <div className="table-wrap"><table className="data">
                <thead><tr><th>Cylinder Type</th><th className="num">Sold</th><th className="num">Returned</th><th className="num">Still With Customer</th><th></th></tr></thead>
                <tbody>{Object.entries(emptyByType).map(([cyl, v]) => (
                  <tr key={cyl}><td><CylRow cyl={cyl} size={30} /></td><td className="num">{v.sold}</td><td className="num txt-green">{v.returned}</td>
                    <td className="num cell-strong">{Math.max(0, v.sold - v.returned)}</td>
                    <td className="num"><button className="btn btn-ghost btn-sm" onClick={() => go('empties')}>Mark returned</button></td></tr>
                ))}</tbody>
              </table></div>
            )}
            {tab === 'notes' && (
              <div>
                <div className="note-box teal mb-4"><WIcons.Info size={16} />{c.notes || 'No notes yet for this customer.'}</div>
                <button className="btn btn-secondary btn-sm"><WIcons.Plus size={14} /> Add note</button>
              </div>
            )}
          </div>
        </div>

        <div className="card card-pad" style={{ alignSelf: 'start' }}>
          <div className="section-title">Balance Summary</div>
          <div className="kv"><span className="k">Total purchased</span><span className="cell-strong">{TKn(stats.totalPurchased)}</span></div>
          <div className="kv"><span className="k">Total paid</span><span className="txt-green">{TKn(stats.totalPaid)}</span></div>
          <div className="kv big"><span>Total due</span><span className={stats.totalDue > 0 ? 'txt-red' : 'txt-green'}>{TKn(stats.totalDue)}</span></div>
          <div className="divider-h" />
          <div className="kv"><span className="k">Total sales</span><span className="cell-strong">{stats.totalSales}</span></div>
          <div className="kv"><span className="k">Empties owed</span><span className="txt-amber">{stats.emptiesOwed}</span></div>
        </div>
      </div>
    </div>
  );
}
Object.assign(window, { DuesPage, CustomersPage, CustomerDetailPage });
