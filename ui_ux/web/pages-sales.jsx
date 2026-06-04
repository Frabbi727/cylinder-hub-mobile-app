// ============ Pages: Sales History + Sale Detail ============
const TODAY = new Date('2026-06-02T12:00:00');

function SalesHistoryPage({ go, t, onCollect }) {
  const [tab, setTab] = useState('all');
  const [payFilter, setPayFilter] = useState('all');
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const sort = useSort('id', 'desc');
  const PER = 8;

  let rows = SALES.filter(s => {
    if (tab === 'today' && s.dt.toDateString() !== TODAY.toDateString()) return false;
    if (tab === 'week' && (TODAY - s.dt) / 86400000 > 7) return false;
    if (tab === 'month' && (TODAY - s.dt) / 86400000 > 31) return false;
    if (payFilter !== 'all' && s.status !== payFilter) return false;
    if (q && !(s.custName || '').toLowerCase().includes(q.toLowerCase())) return false;
    return true;
  });
  rows = sort.sortBy(rows, {
    id: s => s.id, date: s => s.dt, cust: s => s.custName || '', amount: s => s.total,
    paid: s => s.paid, due: s => s.due,
  });
  const pages = Math.ceil(rows.length / PER) || 1;
  const pageRows = rows.slice((page - 1) * PER, page * PER);
  const sums = rows.reduce((a, s) => ({ amt: a.amt + s.total, paid: a.paid + s.paid, due: a.due + s.due }), { amt: 0, paid: 0, due: 0 });

  return (
    <div className="page">
      <div className="page-head">
        <div><h1>{t('nav_sales')}</h1><div className="sub">{rows.length} sales in this view</div></div>
        <div className="head-actions">
          <button className="btn btn-grey"><WIcons.Download size={16} /> {t('export_csv')}</button>
          <button className="btn btn-primary" onClick={() => go('sales/new')}><WIcons.Plus size={16} /> {t('new_sale')}</button>
        </div>
      </div>

      <div className="filter-bar">
        <div className="seg-tabs">
          {[['today', 'Today'], ['week', 'This Week'], ['month', 'This Month'], ['all', 'All']].map(([k, l]) => (
            <button key={k} className={tab === k ? 'on' : ''} onClick={() => { setTab(k); setPage(1); }}>{l}</button>
          ))}
        </div>
        <div className="search-box">
          <span className="ic"><WIcons.Search size={15} /></span>
          <input placeholder="Search customer…" value={q} onChange={e => { setQ(e.target.value); setPage(1); }} />
        </div>
        <select className="select" style={{ width: 160 }} value={payFilter} onChange={e => { setPayFilter(e.target.value); setPage(1); }}>
          <option value="all">All Payments</option><option value="cash">Cash</option><option value="partial">Partial</option><option value="due">Due</option>
        </select>
      </div>

      <div className="card">
        <div className="table-wrap">
          <table className="data">
            <thead><tr>
              <Th k="date" sort={sort}>Date & Time</Th>
              <Th k="cust" sort={sort}>{t('customer')}</Th>
              <th>Cylinder(s)</th>
              <th className="num">Qty</th>
              <Th k="amount" sort={sort} num>{t('amount')}</Th>
              <Th k="paid" sort={sort} num>{t('paid')}</Th>
              <Th k="due" sort={sort} num>{t('due')}</Th>
              <th>{t('status')}</th>
              <th></th>
            </tr></thead>
            <tbody>
              {pageRows.map(s => (
                <tr key={s.id} className={`clickable ${s.overdue ? 'danger-row' : ''}`} onClick={() => go('sales/' + s.id)}>
                  <td><div className="cell-strong">{fmtShortDate(s.dt)}</div><div className="cell-sub">{s.time}</div></td>
                  <td className="cell-strong">{s.custName}</td>
                  <td className="cell-sub">{s.items.map(i => `${cylById(i.cyl).name} ${cylById(i.cyl).size}`).join(', ')}</td>
                  <td className="num">{s.qty}</td>
                  <td className="num cell-strong">{TKn(s.total)}</td>
                  <td className="num txt-green">{s.paid > 0 ? TKn(s.paid) : '—'}</td>
                  <td className="num">{s.due > 0 ? <span className="txt-red">{TKn(s.due)}</span> : '—'}</td>
                  <td><StatusBadge status={s.overdue ? 'overdue' : s.status} /></td>
                  <td><div className="row-actions">
                    <button className="icon-btn" title="View" onClick={(e) => { e.stopPropagation(); go('sales/' + s.id); }}><WIcons.Eye size={16} /></button>
                    {s.due > 0 && <button className="icon-btn" title="Collect" style={{ color: 'var(--success)' }} onClick={(e) => { e.stopPropagation(); onCollect(s); }}><WIcons.Wallet size={16} /></button>}
                  </div></td>
                </tr>
              ))}
              {pageRows.length === 0 && <tr><td colSpan={9}><EmptyState icon={WIcons.Receipt} title="No sales found for this period" /></td></tr>}
            </tbody>
            {rows.length > 0 && <tfoot><tr className="total-row">
              <td colSpan={4}>Total ({rows.length})</td>
              <td className="num">{TKn(sums.amt)}</td><td className="num">{TKn(sums.paid)}</td><td className="num">{TKn(sums.due)}</td><td colSpan={2}></td>
            </tr></tfoot>}
          </table>
        </div>
        <div style={{ padding: '0 16px 14px' }}><Pagination page={page} pages={pages} onChange={setPage} /></div>
      </div>
    </div>
  );
}

function SaleDetailPage({ id, go, t, onCollect, version }) {
  const sale = salesById(Number(id));
  if (!sale) return <div className="page"><EmptyState icon={WIcons.AlertCircle} title="Sale not found" /></div>;
  const emptiesReturned = EMPTY_RETURNS.filter(e => e.custId === sale.custId).reduce((a, e) => a + e.qty, 0);
  return (
    <div className="page">
      <button className="btn btn-ghost btn-sm mb-3" onClick={() => go('sales')}><WIcons.ArrowLeft size={16} /> Back to Sales History</button>
      <div className="two-col">
        <div className="col gap-4">
          <div className="card card-pad">
            <div className="row between">
              <div><h1 style={{ fontSize: 22 }}>Sale #{sale.id}</h1><div className="sub">{fmtDate(sale.dt)} · {sale.time} · {sale.custName}</div></div>
              <StatusBadge status={sale.overdue ? 'overdue' : sale.status} />
            </div>
          </div>

          <div className="card">
            <div className="card-head"><h3>Items</h3><button className="btn btn-grey btn-sm no-print" onClick={() => window.print()}><WIcons.Printer size={15} /> Print Receipt</button></div>
            <div className="table-wrap">
              <table className="data">
                <thead><tr><th>Cylinder Type</th><th className="num">Qty</th><th className="num">Unit Price</th><th className="num">Line Total</th></tr></thead>
                <tbody>
                  {sale.items.map((it, i) => (
                    <tr key={i}><td><CylRow cyl={it.cyl} size={32} /></td><td className="num">{it.qty}</td><td className="num muted">{TKn(it.price)}</td><td className="num cell-strong">{TKn(it.total)}</td></tr>
                  ))}
                </tbody>
                <tfoot><tr className="total-row"><td colSpan={3}>Total</td><td className="num">{TKn(sale.total)}</td></tr></tfoot>
              </table>
            </div>
          </div>

          <div className="card">
            <div className="card-head"><h3>Payment History</h3></div>
            {sale.payments.length === 0 ? <EmptyState icon={WIcons.Wallet} title="No payments yet" /> : (
              <div className="table-wrap"><table className="data">
                <thead><tr><th>Date</th><th className="num">Amount</th><th>Collected by</th><th>Notes</th></tr></thead>
                <tbody>{sale.payments.map((p, i) => (
                  <tr key={i}><td>{p.date}</td><td className="num txt-green">{TKn(p.amount)}</td><td>{p.by}</td><td className="cell-sub">{p.note}</td></tr>
                ))}</tbody>
              </table></div>
            )}
          </div>
        </div>

        <div className="col gap-4">
          <div className="card card-pad">
            <div className="section-title">Payment Summary</div>
            <div className="kv"><span className="k">Total amount</span><span className="cell-strong">{TKn(sale.total)}</span></div>
            <div className="kv"><span className="k">Total paid</span><span className="txt-green">{TKn(sale.paid)}</span></div>
            <div className="kv big"><span>Remaining due</span><span className={sale.due > 0 ? 'txt-red' : 'txt-green'}>{TKn(sale.due)}</span></div>
            {sale.due > 0 && <button className="btn btn-primary btn-block mt-4" onClick={() => onCollect(sale)}><WIcons.Wallet size={16} /> Collect Payment</button>}
          </div>
          <div className="card card-pad">
            <div className="section-title">Empty Cylinders</div>
            <div className="row between"><span className="muted small">Returned for this customer</span><span className="cell-strong">{emptiesReturned}</span></div>
            <div className="row between mt-2"><span className="muted small">Cylinders sold</span><span className="cell-strong">{sale.qty}</span></div>
            <button className="btn btn-secondary btn-sm btn-block mt-3" onClick={() => go('empties')}><WIcons.Package size={15} /> Log Empty Return</button>
          </div>
        </div>
      </div>
    </div>
  );
}
Object.assign(window, { SalesHistoryPage, SaleDetailPage });
