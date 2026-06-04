// ============ Salesman — Dues + Collect + End of Day ============
const { useState, useEffect, useRef, Fragment } = React;
const Ic = window.Icons;

function Dues({ lang, setLang, onCollect, dues }) {
  const totalDue = dues.reduce((a, d) => a + d.due, 0);
  return (
    <div style={{ display: 'contents' }}>
      <AppBar title={t('outstanding')} accent={ACCENT.dues} lang={lang} setLang={setLang}>
        <div className="card card-pad" style={{ marginTop: 16, background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.18)', boxShadow: 'none' }}>
          <div style={{ color: 'rgba(255,255,255,0.78)', fontSize: 12.5, fontWeight: 600 }}>{t('totalDue')}</div>
          <div className="taka" style={{ color: '#fff', fontSize: 30, fontWeight: 800, marginTop: 2 }}>{TK(totalDue)}</div>
          <div style={{ color: 'rgba(255,255,255,0.72)', fontSize: 12.5, marginTop: 2 }}>{dues.length} customers</div>
        </div>
      </AppBar>
      <div className="sm-main route-fade">
        {dues.length === 0 ? (
          <div className="empty"><span className="ico"><Ic.Check size={30} strokeWidth={2.6} /></span><div>{t('noDues')}</div></div>
        ) : dues.map((d) => {
          const c = cylById(d.cyl);
          return (
            <div key={d.id} className="card" style={{ marginBottom: 12 }}>
              <div className="lrow" style={{ paddingBottom: 12 }}>
                <Cyl id={d.cyl} size="sm" />
                <div className="grow">
                  <div className="t1 ellipsis">{d.customer}</div>
                  <div className="t2">{d.qty} × {c.size} · #{d.id}</div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div className="amt taka" style={{ color: 'var(--red-ink)' }}>{TK(d.due)}</div>
                  <div className="tiny dim" style={{ marginTop: 2 }}>{d.age}</div>
                </div>
              </div>
              <div className="divider"></div>
              <div className="row" style={{ gap: 10, padding: 10 }}>
                <a className="btn btn-line btn-sm" style={{ flex: 1, textDecoration: 'none' }} href={d.phone ? 'tel:' + d.phone : undefined}>
                  <Ic.Phone size={16} /> {t('callCustomer')}
                </a>
                <button className="btn btn-green btn-sm" style={{ flex: 1.4 }} onClick={() => onCollect(d)}>
                  <Ic.Wallet size={16} /> {t('collect')}
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function CollectSheet({ due, onClose, onConfirm }) {
  const [amt, setAmt] = useState(String(due.due));
  const c = cylById(due.cyl);
  const num = parseInt(amt || '0', 10) || 0;
  const remaining = Math.max(0, due.due - num);
  return (
    <div className="sheet-scrim" onClick={onClose}>
      <div className="sheet" onClick={(e) => e.stopPropagation()}>
        <div className="grab"></div>
        <div className="row between" style={{ marginBottom: 16 }}>
          <div style={{ fontSize: 19, fontWeight: 800 }}>{t('collect')}</div>
          <button className="hdr-btn" style={{ background: 'var(--line-2)', color: 'var(--text-2)', width: 36, height: 36 }} onClick={onClose}><Ic.X size={18} /></button>
        </div>

        <div className="card card-pad" style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, background: 'var(--bg)', border: 'none' }}>
          <Cyl id={due.cyl} />
          <div className="grow">
            <div className="t1">{due.customer}</div>
            <div className="t2">{due.qty} × {c.size} · #{due.id}</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div className="tiny dim">{t('due')}</div>
            <div className="taka" style={{ fontSize: 18, fontWeight: 800, color: 'var(--red-ink)' }}>{TK(due.due)}</div>
          </div>
        </div>

        <label className="field">
          <span className="lbl">{t('amountToCollect')}</span>
          <div className="input-icon">
            <span className="ic" style={{ fontWeight: 700, fontSize: 18 }}>৳</span>
            <input className="input" type="number" inputMode="numeric" value={amt}
              onChange={(e) => setAmt(e.target.value)} style={{ fontSize: 22, fontWeight: 800, height: 60 }} />
          </div>
        </label>
        <button className="pill teal" style={{ height: 36, padding: '0 14px', marginBottom: 16 }} onClick={() => setAmt(String(due.due))}>
          {t('fullAmount')} · {TK(due.due)}
        </button>

        {remaining > 0 && (
          <div className="tiny" style={{ color: 'var(--orange-ink)', fontWeight: 600, marginBottom: 14 }}>
            {TK(remaining)} {t('due')} will remain
          </div>
        )}

        <button className="btn btn-green btn-block" disabled={num <= 0} onClick={() => onConfirm(num)}>
          <Ic.Check size={20} strokeWidth={2.6} /> {t('collect')} · {TK(num)}
        </button>
      </div>
    </div>
  );
}

function EndOfDay({ go, onDone, lang, setLang }) {
  const [step, setStep] = useState(0);
  const tot = dayTotals();
  const labels = ['Stock', 'Cash', 'Confirm'];

  const next = () => step < 2 ? setStep(step + 1) : onDone(t('saleRecorded'));
  const back = () => step > 0 ? setStep(step - 1) : go('home');

  return (
    <div style={{ display: 'contents' }}>
      <AppBar title={t('endOfDay')} accent={ACCENT.eod} sub={'Step ' + (step + 1) + ' of 3 · ' + labels[step]} lang={lang} setLang={setLang} back={back} />
      <div className="sm-main route-fade">
        <div className="steps" style={{ marginBottom: 22 }}>
          {[0, 1, 2].map((i) => (
            <Fragment key={i}>
              {i > 0 && <div className={'ln' + (i <= step ? ' done' : '')}></div>}
              <div className={'s' + (i === step ? ' on' : i < step ? ' done' : '')}>
                {i < step ? <Ic.Check size={15} strokeWidth={3} /> : i + 1}
              </div>
            </Fragment>
          ))}
        </div>

        {step === 0 && (
          <div className="route-fade">
            <div className="sect-label">Stock reconciliation</div>
            <div className="card card-pad">
              {MY_ALLOC.map((a, i) => {
                const c = cylById(a.cyl);
                const ret = a.alloc - a.sold;
                return (
                  <div key={a.cyl} className="recon-row">
                    <Cyl id={a.cyl} size="sm" />
                    <div className="grow">
                      <div className="t1" style={{ fontSize: 14 }}>{c.name} · {c.size}</div>
                      <div className="t2">{a.alloc} allocated · {a.sold} sold</div>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <div style={{ fontSize: 17, fontWeight: 800 }}>{ret}</div>
                      <div className="tiny dim">returning</div>
                    </div>
                  </div>
                );
              })}
            </div>
            <div className="card card-pad" style={{ marginTop: 12, background: 'var(--orange-bg)', border: 'none', display: 'flex', gap: 10, alignItems: 'center' }}>
              <Ic.RefreshCw size={18} style={{ color: 'var(--orange-ink)', flex: 'none' }} />
              <div className="tiny" style={{ color: 'var(--orange-ink)', fontWeight: 600 }}>{tot.emptiesBack} empty cylinders returning to depot</div>
            </div>
          </div>
        )}

        {step === 1 && (
          <div className="route-fade">
            <div className="sect-label">Cash summary</div>
            <div className="card">
              <CashRow label={t('collected')} val={TK(tot.collected)} tone="var(--green-ink)" />
              <CashRow label={t('toCollect')} val={TK(tot.dueToday)} tone="var(--red-ink)" />
              <CashRow label={t('soldToday') + ' (units)'} val={tot.soldUnits} />
              <CashRow label="Sales count" val={tot.sales} last />
            </div>
            <div className="card card-pad" style={{ marginTop: 12, background: 'var(--teal-light)', border: 'none' }}>
              <div className="row between">
                <span style={{ fontWeight: 700, color: 'var(--blue-ink)' }}>Cash to hand over</span>
                <span className="taka" style={{ fontSize: 24, fontWeight: 800, color: 'var(--blue-ink)' }}>{TK(tot.collected)}</span>
              </div>
            </div>
          </div>
        )}

        {step === 2 && (
          <div className="route-fade" style={{ textAlign: 'center', paddingTop: 12 }}>
            <div className="empty" style={{ padding: '20px 10px' }}>
              <span className="ico" style={{ width: 76, height: 76 }}><Ic.Send size={32} /></span>
              <div style={{ fontSize: 19, fontWeight: 800, color: 'var(--text-1)', marginBottom: 6 }}>Submit to admin</div>
              <div className="tiny muted" style={{ maxWidth: 250, margin: '0 auto' }}>{t('reconcileDesc')}. The admin will verify and close your day.</div>
            </div>
            <div className="card" style={{ textAlign: 'left' }}>
              <CashRow label="Stock returning" val={tot.allocUnits - tot.soldUnits + ' units'} />
              <CashRow label="Empties returning" val={tot.emptiesBack} />
              <CashRow label="Cash handover" val={TK(tot.collected)} tone="var(--green-ink)" last />
            </div>
          </div>
        )}

        <div className="row" style={{ gap: 12, marginTop: 20 }}>
          <button className="btn btn-line" style={{ flex: 1 }} onClick={back}>{t('back')}</button>
          <button className={'btn ' + (step === 2 ? 'btn-green' : 'btn-primary')} style={{ flex: 1.6 }} onClick={next}>
            {step === 2 ? <Fragment><Ic.Send size={18} /> {t('submit')}</Fragment> : <Fragment>{t('next')} <Ic.ArrowRight size={18} /></Fragment>}
          </button>
        </div>
      </div>
    </div>
  );
}

function CashRow({ label, val, tone, last }) {
  return (
    <div className="lrow between" style={{ padding: '14px 16px', ...(last ? {} : { borderBottom: '1px solid var(--line-2)' }) }}>
      <span className="muted" style={{ fontSize: 14 }}>{label}</span>
      <span className="taka" style={{ fontSize: 16, fontWeight: 800, color: tone || 'var(--text-1)' }}>{val}</span>
    </div>
  );
}

Object.assign(window, { Dues, CollectSheet, EndOfDay, CashRow });
