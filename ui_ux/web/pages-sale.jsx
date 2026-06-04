// ============ Page: New Sale ============
function NewSalePage({ go, t }) {
  const toast = useToast();
  const allocCyls = ALLOCATIONS.map(a => ({ ...a, remaining: a.allocated - a.sold - a.returned, c: cylById(a.cyl) }));
  const [custQuery, setCustQuery] = useState('');
  const [customer, setCustomer] = useState({ id: 'walkin', name: 'Walk-in' });
  const [showCustList, setShowCustList] = useState(false);
  const [showAddCust, setShowAddCust] = useState(false);
  const [newCust, setNewCust] = useState({ name: '', phone: '' });
  const [rows, setRows] = useState([{ cyl: allocCyls[0].cyl, qty: 1 }]);
  const [pay, setPay] = useState('cash');
  const [paidAmt, setPaidAmt] = useState('');
  const [notes, setNotes] = useState('');

  const matches = CUSTOMERS.filter(c => c.name.toLowerCase().includes(custQuery.toLowerCase()) || c.phone.includes(custQuery));

  const lineTotal = (r) => (CYL_PRICE[r.cyl] || 0) * r.qty;
  const subtotal = rows.reduce((a, r) => a + lineTotal(r), 0);
  const paid = pay === 'cash' ? subtotal : pay === 'partial' ? Number(paidAmt || 0) : 0;
  const due = subtotal - paid;

  const remainingFor = (cyl) => (allocCyls.find(a => a.cyl === cyl) || {}).remaining || 0;

  const setRow = (i, patch) => setRows(rs => rs.map((r, j) => j === i ? { ...r, ...patch } : r));
  const addRow = () => {
    const used = rows.map(r => r.cyl);
    const avail = allocCyls.find(a => !used.includes(a.cyl)) || allocCyls[0];
    setRows(rs => [...rs, { cyl: avail.cyl, qty: 1 }]);
  };
  const removeRow = (i) => setRows(rs => rs.filter((_, j) => j !== i));

  const submit = () => {
    toast(`Sale recorded for ${customer.name} — ${TKn(subtotal)}`);
    setTimeout(() => go('sales/142'), 400);
  };

  useEffect(() => {
    const h = (e) => { if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') submit(); };
    window.addEventListener('keydown', h);
    return () => window.removeEventListener('keydown', h);
  });

  const overSell = rows.some(r => r.qty > remainingFor(r.cyl));

  return (
    <div className="page">
      <div className="page-head">
        <div><h1>{t('new_sale')}</h1><div className="sub">Record a sale from your allocated stock</div></div>
        <button className="btn btn-grey" onClick={() => go('dashboard')}><WIcons.ArrowLeft size={16} /> Cancel</button>
      </div>

      <div className="two-col">
        {/* form */}
        <div className="col gap-4">
          <div className="card card-pad">
            <div className="section-title">Customer</div>
            <div style={{ position: 'relative' }}>
              <div className="row between">
                <div className="row gap-3">
                  <span className="sb-avatar" style={{ background: 'linear-gradient(135deg,#2BB3C0,#0E7B86)' }}>{customer.name === 'Walk-in' ? 'W' : customer.name.split(' ').map(x => x[0]).slice(0, 2).join('')}</span>
                  <div><div className="cell-strong">{customer.name}</div><div className="muted tiny">{customer.phone || 'No phone'}</div></div>
                </div>
                <div className="row gap-2">
                  <button className="btn btn-grey btn-sm" onClick={() => setShowCustList(s => !s)}><WIcons.Search size={14} /> Change</button>
                  <button className="btn btn-secondary btn-sm" onClick={() => setShowAddCust(true)}><WIcons.Plus size={14} /> New</button>
                </div>
              </div>
              {showCustList && (
                <div className="card mt-3" style={{ boxShadow: 'var(--shadow)' }}>
                  <div style={{ padding: 10 }}>
                    <div className="search-box" style={{ maxWidth: 'none' }}>
                      <span className="ic"><WIcons.Search size={15} /></span>
                      <input autoFocus placeholder="Search name or phone…" value={custQuery} onChange={e => setCustQuery(e.target.value)} />
                    </div>
                  </div>
                  <div style={{ maxHeight: 200, overflowY: 'auto' }}>
                    <div className="sb-link" style={{ color: 'var(--text-1)', borderRadius: 0, borderLeft: 0, padding: '10px 16px' }}
                      onClick={() => { setCustomer({ id: 'walkin', name: 'Walk-in' }); setShowCustList(false); }}>Walk-in customer</div>
                    {matches.map(c => (
                      <div key={c.id} style={{ padding: '10px 16px', cursor: 'pointer', borderTop: '1px solid var(--border-soft)' }}
                        onClick={() => { setCustomer(c); setShowCustList(false); }}
                        onMouseEnter={e => e.currentTarget.style.background = 'var(--teal-light)'}
                        onMouseLeave={e => e.currentTarget.style.background = '#fff'}>
                        <div className="cell-strong">{c.name}</div><div className="muted tiny">{c.phone}</div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>

          <div className="card">
            <div className="card-head"><h3>Items</h3></div>
            <div className="table-wrap">
              <table className="data">
                <thead><tr><th>Cylinder Type</th><th style={{ width: 150 }}>Qty</th><th className="num">Unit Price</th><th className="num">Line Total</th><th></th></tr></thead>
                <tbody>
                  {rows.map((r, i) => {
                    const rem = remainingFor(r.cyl);
                    const over = r.qty > rem;
                    return (
                      <tr key={i}>
                        <td>
                          <select className="select" value={r.cyl} onChange={e => setRow(i, { cyl: e.target.value })}>
                            {allocCyls.map(a => <option key={a.cyl} value={a.cyl}>{a.c.name} {a.c.size} ({a.remaining} left)</option>)}
                          </select>
                        </td>
                        <td>
                          <div className="stepper">
                            <button onClick={() => setRow(i, { qty: Math.max(1, r.qty - 1) })}><WIcons.Minus size={15} /></button>
                            <span className="val">{r.qty}</span>
                            <button disabled={r.qty >= rem} onClick={() => setRow(i, { qty: r.qty + 1 })}><WIcons.Plus size={15} /></button>
                          </div>
                          {over && <div className="err-msg">Only {rem} available</div>}
                        </td>
                        <td className="num muted">{TKn(CYL_PRICE[r.cyl])}</td>
                        <td className="num cell-strong">{TKn(lineTotal(r))}</td>
                        <td className="num">{rows.length > 1 && <button className="icon-btn" onClick={() => removeRow(i)} style={{ color: 'var(--danger)' }}><WIcons.X size={16} /></button>}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
            <div style={{ padding: 14 }}><button className="btn btn-secondary btn-sm" onClick={addRow}><WIcons.Plus size={15} /> Add Item</button></div>
          </div>

          <div className="card card-pad">
            <div className="section-title">Payment</div>
            <div className="pay-cards">
              {[
                { k: 'cash', t: 'CASH', s: 'Paid in full', ic: WIcons.Wallet, tone: 'green' },
                { k: 'partial', t: 'PARTIAL', s: 'Some paid now', ic: WIcons.Dollar, tone: 'amber' },
                { k: 'due', t: 'DUE LATER', s: 'Nothing paid', ic: WIcons.Clock, tone: 'red' },
              ].map(p => (
                <div key={p.k} className={`pay-card ${pay === p.k ? 'on' : ''}`} onClick={() => setPay(p.k)}>
                  <span className={`pc-ic ic ${p.tone}`}><p.ic size={20} /></span>
                  <div className="pc-t">{p.t}</div><div className="pc-s">{p.s}</div>
                </div>
              ))}
            </div>
            {pay === 'partial' && (
              <label className="field mt-4" style={{ marginBottom: 0 }}>
                <span className="lbl">Amount paid now <span className="req">*</span></span>
                <input className="input" type="number" max={subtotal} placeholder="0" value={paidAmt} onChange={e => setPaidAmt(e.target.value)} />
                <div className="muted tiny mt-2">Due after this payment: <strong className="txt-red">{TKn(Math.max(0, subtotal - Number(paidAmt || 0)))}</strong></div>
              </label>
            )}
          </div>

          <div className="card card-pad">
            <div className="grid-2">
              <label className="field" style={{ marginBottom: 0 }}>
                <span className="lbl">Sale date</span>
                <input className="input" type="date" defaultValue="2026-06-02" />
              </label>
              <label className="field" style={{ marginBottom: 0 }}>
                <span className="lbl">Notes (optional)</span>
                <input className="input" placeholder="Add a note…" value={notes} onChange={e => setNotes(e.target.value)} />
              </label>
            </div>
          </div>
        </div>

        {/* live summary */}
        <div className="summary-sticky">
          <div className="card card-pad">
            <div className="section-title">Order Summary</div>
            <div className="row gap-2 mb-3"><WIcons.Users size={15} className="muted" /><span className="cell-strong">{customer.name}</span></div>
            <div className="divider-h" />
            {rows.map((r, i) => (
              <div key={i} className="row between small" style={{ padding: '5px 0' }}>
                <span>{r.qty}× {cylById(r.cyl).name} {cylById(r.cyl).size}</span>
                <span className="cell-strong">{TKn(lineTotal(r))}</span>
              </div>
            ))}
            <div className="divider-h" />
            <div className="kv"><span className="k">Subtotal</span><span className="cell-strong">{TKn(subtotal)}</span></div>
            <div className="kv"><span className="k">Paid</span><span className="txt-green">{TKn(paid)}</span></div>
            <div className="kv"><span className="k">Due</span><span className="txt-red">{TKn(due)}</span></div>
            <div className="kv big"><span>Total</span><span style={{ color: 'var(--primary)' }}>{TKn(subtotal)}</span></div>
            <button className="btn btn-primary btn-lg btn-block mt-4" disabled={overSell || subtotal === 0} onClick={submit}>
              <WIcons.Check size={18} /> {t('record_sale')}
            </button>
            <div className="center dim tiny mt-3">Ctrl + Enter to submit</div>
          </div>
        </div>
      </div>

      {showAddCust && (
        <Modal title="Add New Customer" onClose={() => setShowAddCust(false)}
          footer={<>
            <button className="btn btn-grey" onClick={() => setShowAddCust(false)}>Cancel</button>
            <button className="btn btn-primary" disabled={!newCust.name || !newCust.phone}
              onClick={() => { setCustomer({ id: 'new', name: newCust.name, phone: newCust.phone }); setShowAddCust(false); toast('Customer added'); }}>Add Customer</button>
          </>}>
          <label className="field"><span className="lbl">Name <span className="req">*</span></span>
            <input className="input" value={newCust.name} onChange={e => setNewCust(c => ({ ...c, name: e.target.value }))} /></label>
          <label className="field" style={{ marginBottom: 0 }}><span className="lbl">Phone <span className="req">*</span></span>
            <input className="input" value={newCust.phone} onChange={e => setNewCust(c => ({ ...c, phone: e.target.value }))} /></label>
        </Modal>
      )}
    </div>
  );
}
Object.assign(window, { NewSalePage });
