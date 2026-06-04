// ============ Salesman — New Sale + Sales History ============
const { useState, useEffect, useRef, Fragment } = React;
const Ic = window.Icons;

function NewSale({ go, onDone, lang, setLang }) {
  const allocCyls = MY_ALLOC.map((a) => a.cyl);
  const [cyl, setCyl] = useState(allocCyls[0]);
  const [qty, setQty] = useState(1);
  const [price, setPrice] = useState(PRICE[allocCyls[0]]);
  const [cust, setCust] = useState('');
  const [phone, setPhone] = useState('');
  const [pay, setPay] = useState('Cash');
  const [paid, setPaid] = useState('');
  const [empties, setEmpties] = useState(0);
  const [showSug, setShowSug] = useState(false);

  const total = qty * price;
  const paidNum = pay === 'Cash' ? total : pay === 'Due' ? 0 : (parseInt(paid || '0', 10) || 0);
  const dueNum = Math.max(0, total - paidNum);

  const pickCyl = (id) => { setCyl(id); setPrice(PRICE[id]); };
  const sugs = CUSTOMERS.filter((c) => c.name.toLowerCase().includes(cust.toLowerCase())).slice(0, 4);

  return (
    <div style={{ display: 'contents' }}>
      <AppBar title={t('newSale')} accent={ACCENT.sell} sub={cylById(cyl).name + ' · ' + cylById(cyl).size} lang={lang} setLang={setLang} />
      <div className="sm-main route-fade">
        {/* cylinder picker */}
        <div className="field">
          <span className="lbl">{t('cylinder')}</span>
          <div className="row" style={{ gap: 10, overflowX: 'auto', paddingBottom: 2 }}>
            {MY_ALLOC.map((a) => {
              const c = cylById(a.cyl);
              const left = a.alloc - a.sold;
              const on = a.cyl === cyl;
              return (
                <button key={a.cyl} onClick={() => pickCyl(a.cyl)}
                  className="card" style={{ flex: 'none', padding: '12px 14px', display: 'flex', alignItems: 'center', gap: 10,
                    borderColor: on ? 'var(--teal)' : 'var(--line)', borderWidth: on ? 2 : 1,
                    background: on ? 'var(--teal-light)' : 'var(--surface)', borderStyle: 'solid' }}>
                  <Cyl id={a.cyl} size="sm" />
                  <div style={{ textAlign: 'left' }}>
                    <div style={{ fontSize: 13.5, fontWeight: 700, whiteSpace: 'nowrap' }}>{c.size}</div>
                    <div className="tiny dim" style={{ whiteSpace: 'nowrap' }}>{left} {t('left')}</div>
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* qty + price */}
        <div className="row" style={{ gap: 12, alignItems: 'flex-start' }}>
          <div className="field" style={{ flex: 1.2 }}>
            <span className="lbl">{t('quantity')}</span>
            <div className="card" style={{ padding: 6 }}>
              <div className="stepper">
                <button onClick={() => setQty(Math.max(1, qty - 1))}><Ic.Minus size={20} /></button>
                <div className="val">{qty}</div>
                <button onClick={() => setQty(qty + 1)}><Ic.Plus size={20} /></button>
              </div>
            </div>
          </div>
          <label className="field" style={{ flex: 1 }}>
            <span className="lbl">{t('pricePiece')}</span>
            <div className="input-icon">
              <span className="ic" style={{ fontWeight: 700 }}>৳</span>
              <input className="input" type="number" inputMode="numeric" value={price}
                onChange={(e) => setPrice(parseInt(e.target.value || '0', 10) || 0)} />
            </div>
          </label>
        </div>

        {/* customer */}
        <label className="field" style={{ position: 'relative' }}>
          <span className="lbl">{t('customer')}</span>
          <div className="input-icon">
            <span className="ic"><Ic.Users size={18} /></span>
            <input className="input" placeholder={t('search')} value={cust}
              onFocus={() => setShowSug(true)}
              onChange={(e) => { setCust(e.target.value); setShowSug(true); }} />
          </div>
          {showSug && cust && sugs.length > 0 && (
            <div className="card" style={{ position: 'absolute', top: '100%', left: 0, right: 0, marginTop: 4, zIndex: 5, boxShadow: 'var(--shadow-lg)' }}>
              {sugs.map((s, i) => (
                <div key={s.name} className="lrow" style={{ padding: '11px 14px', ...(i ? { borderTop: '1px solid var(--line-2)' } : {}) }}
                  onClick={() => { setCust(s.name); setPhone(s.phone); setShowSug(false); }}>
                  <span className="avatar" style={{ width: 34, height: 34, fontSize: 13, background: 'var(--blue-bg)', color: 'var(--blue-ink)' }}>{s.name[0]}</span>
                  <div className="grow"><div className="t1" style={{ fontSize: 14 }}>{s.name}</div><div className="t2">{s.phone}</div></div>
                </div>
              ))}
            </div>
          )}
        </label>

        <label className="field">
          <span className="lbl">{t('phone')}</span>
          <div className="input-icon">
            <span className="ic"><Ic.Phone size={18} /></span>
            <input className="input" inputMode="tel" placeholder="01XXX-XXXXXX" value={phone} onChange={(e) => setPhone(e.target.value)} />
          </div>
        </label>

        {/* payment */}
        <div className="field">
          <span className="lbl">{t('payment')}</span>
          <div className="seg pay">
            {[['Cash', 'cash'], ['Due', 'due'], ['Partial', 'partial']].map(([p, k]) => (
              <button key={p} className={(pay === p ? 'on ' : '') + k} onClick={() => setPay(p)}>
                {pay === p && <Ic.Check size={15} strokeWidth={3} />}{t(k)}
              </button>
            ))}
          </div>
        </div>

        {pay === 'Partial' && (
          <label className="field route-fade">
            <span className="lbl">{t('amountPaid')}</span>
            <div className="input-icon">
              <span className="ic" style={{ fontWeight: 700 }}>৳</span>
              <input className="input" type="number" inputMode="numeric" placeholder="0" value={paid}
                onChange={(e) => setPaid(e.target.value)} />
            </div>
          </label>
        )}

        {/* empties */}
        <div className="field">
          <span className="lbl">{t('emptiesReturned')}</span>
          <div className="card row between" style={{ padding: '10px 10px 10px 16px' }}>
            <div className="row" style={{ gap: 10 }}>
              <span className="ico ico-orange" style={{ width: 38, height: 38, marginBottom: 0 }}><Ic.RefreshCw size={18} /></span>
              <span className="tiny muted" style={{ maxWidth: 130 }}>Empty cylinders taken back from customer</span>
            </div>
            <div className="stepper" style={{ transform: 'scale(0.86)', transformOrigin: 'right' }}>
              <button onClick={() => setEmpties(Math.max(0, empties - 1))}><Ic.Minus size={20} /></button>
              <div className="val" style={{ minWidth: 40 }}>{empties}</div>
              <button onClick={() => setEmpties(empties + 1)}><Ic.Plus size={20} /></button>
            </div>
          </div>
        </div>

        {/* summary */}
        <div className="card card-pad" style={{ background: 'var(--teal-light)', borderColor: 'var(--teal-line)', marginBottom: 16 }}>
          <div className="row between" style={{ marginBottom: dueNum ? 8 : 0 }}>
            <span style={{ fontWeight: 700, color: 'var(--blue-ink)' }}>{t('total')}</span>
            <span className="taka" style={{ fontSize: 26, fontWeight: 800, color: 'var(--blue-ink)' }}>{TK(total)}</span>
          </div>
          {dueNum > 0 && (
            <div className="row between tiny" style={{ color: 'var(--blue-ink)', fontWeight: 600 }}>
              <span>{t('amountPaid')}: <span className="taka">{TK(paidNum)}</span></span>
              <span style={{ color: 'var(--red-ink)' }}>{t('due')}: <span className="taka">{TK(dueNum)}</span></span>
            </div>
          )}
        </div>

        <button className="btn btn-primary btn-block" disabled={!cust}
          onClick={() => onDone(t('saleRecorded'))}>
          <Ic.Check size={20} strokeWidth={2.6} /> {t('confirmSale')}
        </button>
      </div>
    </div>
  );
}

function History({ lang, setLang }) {
  const [q, setQ] = useState('');
  const [filt, setFilt] = useState('All');
  const filters = [['All', 'all'], ['Cash', 'cash'], ['Due', 'due'], ['Partial', 'partial']];
  const list = MY_SALES.filter((s) =>
    (filt === 'All' || s.pay === filt) &&
    (!q || s.customer.toLowerCase().includes(q.toLowerCase()))
  );
  const total = list.reduce((a, s) => a + s.qty * s.price, 0);

  return (
    <div style={{ display: 'contents' }}>
      <AppBar title={t('salesHistory')} accent={ACCENT.history} sub={MY_SALES.length + ' sales today · ' + TK(total)} lang={lang} setLang={setLang} />
      <div className="sm-main">
        <div className="input-icon" style={{ marginBottom: 12 }}>
          <span className="ic"><Ic.Search size={18} /></span>
          <input className="input" placeholder={t('search')} value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
        <div className="row" style={{ gap: 8, marginBottom: 16, overflowX: 'auto' }}>
          {filters.map(([f, k]) => (
            <button key={f} className={'pill' + (filt === f ? ' teal' : '')} style={{ flex: 'none', height: 36, padding: '0 16px', fontSize: 13, ...(filt === f ? { background: 'var(--blue)', color: '#fff' } : {}) }}
              onClick={() => setFilt(f)}>{t(k)}</button>
          ))}
        </div>
        {list.length === 0 ? (
          <div className="empty"><span className="ico"><Ic.Receipt size={28} /></span><div>No sales found</div></div>
        ) : (
          <div className="card route-fade">
            {list.map((s, i) => <SaleRow key={s.id} s={s} first={i === 0} />)}
          </div>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { NewSale, History });
