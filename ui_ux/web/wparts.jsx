// ============ Salesman Web — shared components ============
const { useState, useEffect, useRef, createContext, useContext, useCallback } = React;

// ---- supplementary icons (merge with window.Icons) ----
const XI = ({ children, size = 18, sw = 2, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor"
    strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round" style={style}>{children}</svg>
);
const WIcons = Object.assign({}, window.Icons, {
  Moon: (p) => <XI {...p}><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></XI>,
  Printer: (p) => <XI {...p}><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></XI>,
  Download: (p) => <XI {...p}><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></XI>,
  PlusCircle: (p) => <XI {...p}><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></XI>,
  AlertCircle: (p) => <XI {...p}><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></XI>,
  CheckCircle: (p) => <XI {...p}><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></XI>,
  PhoneIcon: (p) => <XI {...p}><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92Z"/></XI>,
  Sun: (p) => <XI {...p}><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M6.3 17.7l-1.4 1.4M19.1 4.9l-1.4 1.4"/></XI>,
});

const TKn = (n) => '৳' + Number(Math.round(n)).toLocaleString('en-US');

// ---- Cylinder avatar ----
function CylAva({ cyl, size = 38 }) {
  const c = cylById(cyl) || { c1: '#888', c2: '#555', short: '?' };
  return (
    <div className="cyl-ava" style={{ width: size, height: size, background: `linear-gradient(135deg, ${c.c1}, ${c.c2})` }}>
      {c.short}
    </div>
  );
}
function CylRow({ cyl, size = 38 }) {
  const c = cylById(cyl) || {};
  return (
    <div className="cyl-row">
      <CylAva cyl={cyl} size={size} />
      <div>
        <div className="nm">{c.name}</div>
        <div className="sz">{c.size}</div>
      </div>
    </div>
  );
}

// ---- Status badge ----
const STATUS_MAP = {
  cash: { cls: 'badge-cash', label: 'CASH' },
  partial: { cls: 'badge-partial', label: 'PARTIAL' },
  due: { cls: 'badge-due', label: 'DUE' },
  reconciled: { cls: 'badge-reconciled', label: 'RECONCILED' },
  extra: { cls: 'badge-extra', label: 'EXTRA' },
  overdue: { cls: 'badge-overdue', label: 'OVERDUE' },
};
function StatusBadge({ status }) {
  const m = STATUS_MAP[status] || { cls: 'badge-soft-teal', label: (status || '').toUpperCase() };
  return <span className={`badge ${m.cls}`}>{m.label}</span>;
}

// ---- Stat card ----
function StatCard({ icon, tone, label, value, delta, deltaDir }) {
  const Ic = icon;
  return (
    <div className="stat">
      <div className="top">
        <span className={`ic ${tone}`}><Ic size={20} /></span>
        <span className="lbl">{label}</span>
      </div>
      <div className="num">{value}</div>
      {delta != null && (
        <div className={`delta ${deltaDir}`}>
          {deltaDir === 'up' ? <WIcons.TrendUp size={14} /> : <WIcons.TrendDown size={14} />}
          {delta} vs yesterday
        </div>
      )}
    </div>
  );
}

// ---- Modal ----
function Modal({ title, onClose, children, footer, wide }) {
  useEffect(() => {
    const h = (e) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', h);
    return () => window.removeEventListener('keydown', h);
  }, [onClose]);
  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className={`modal ${wide ? 'wide' : ''}`} onClick={(e) => e.stopPropagation()}>
        <div className="modal-head">
          <h3>{title}</h3>
          <button className="icon-btn" onClick={onClose}><WIcons.X size={20} /></button>
        </div>
        <div className="modal-body">{children}</div>
        {footer && <div className="modal-foot">{footer}</div>}
      </div>
    </div>
  );
}

// ---- Toast ----
const ToastCtx = createContext(null);
function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);
  const push = useCallback((msg, type = 'ok') => {
    const id = Math.random().toString(36).slice(2);
    setToasts(t => [...t, { id, msg, type }]);
    setTimeout(() => setToasts(t => t.filter(x => x.id !== id)), 3200);
  }, []);
  return (
    <ToastCtx.Provider value={push}>
      {children}
      <div className="toast-wrap">
        {toasts.map(t => (
          <div key={t.id} className={`toast ${t.type === 'err' ? 'err' : ''}`}>
            <span className="t-ic" style={{ color: t.type === 'err' ? 'var(--danger)' : 'var(--success)' }}>
              {t.type === 'err' ? <WIcons.AlertCircle size={20} /> : <WIcons.CheckCircle size={20} />}
            </span>
            <span className="t-msg">{t.msg}</span>
          </div>
        ))}
      </div>
    </ToastCtx.Provider>
  );
}
const useToast = () => useContext(ToastCtx);

// ---- Empty state ----
function EmptyState({ icon, title, sub, good }) {
  const Ic = icon || WIcons.Info;
  return (
    <div className={`empty-state ${good ? 'good' : ''}`}>
      <div className="em-ic"><Ic size={32} /></div>
      <h3>{title}</h3>
      {sub && <p>{sub}</p>}
    </div>
  );
}

// ---- Pagination ----
function Pagination({ page, pages, onChange }) {
  if (pages <= 1) return null;
  return (
    <div className="pagination">
      <span className="muted tiny">Page {page} of {pages}</span>
      <div className="pages">
        <button className="pg" disabled={page === 1} onClick={() => onChange(page - 1)}><WIcons.ChevronLeft size={16} /></button>
        {Array.from({ length: pages }, (_, i) => i + 1).map(n => (
          <button key={n} className={`pg ${n === page ? 'on' : ''}`} onClick={() => onChange(n)}>{n}</button>
        ))}
        <button className="pg" disabled={page === pages} onClick={() => onChange(page + 1)}><WIcons.ChevronRight size={16} /></button>
      </div>
    </div>
  );
}

// ---- Sortable table header helper ----
function useSort(initialKey, initialDir = 'asc') {
  const [sortKey, setSortKey] = useState(initialKey);
  const [sortDir, setSortDir] = useState(initialDir);
  const toggle = (key) => {
    if (key === sortKey) setSortDir(d => d === 'asc' ? 'desc' : 'asc');
    else { setSortKey(key); setSortDir('asc'); }
  };
  const sortBy = (arr, accessors) => {
    const acc = accessors[sortKey];
    if (!acc) return arr;
    return [...arr].sort((a, b) => {
      const va = acc(a), vb = acc(b);
      if (va < vb) return sortDir === 'asc' ? -1 : 1;
      if (va > vb) return sortDir === 'asc' ? 1 : -1;
      return 0;
    });
  };
  return { sortKey, sortDir, toggle, sortBy };
}
function Th({ k, sort, children, num, onClick }) {
  const active = sort && sort.sortKey === k;
  return (
    <th className={`${num ? 'num' : ''} ${k ? 'sortable' : ''} ${active ? 'sorted' : ''}`}
        onClick={onClick || (k && sort ? () => sort.toggle(k) : undefined)}>
      {children}
      {k && (
        <span className="sort-ic">
          {active && sort.sortDir === 'desc'
            ? <WIcons.ChevronDown size={13} style={{ verticalAlign: 'middle' }} />
            : <WIcons.ChevronDown size={13} style={{ verticalAlign: 'middle', transform: active ? 'rotate(180deg)' : 'none' }} />}
        </span>
      )}
    </th>
  );
}

// ---- Collect Payment modal (shared) ----
function CollectModal({ sale, onClose, onCollect }) {
  const [amt, setAmt] = useState(sale.due);
  const [note, setNote] = useState('');
  const t = new Date('2026-06-02');
  return (
    <Modal title={`Collect Payment — Sale #${sale.id}`} onClose={onClose}
      footer={<>
        <button className="btn btn-grey" onClick={onClose}>Cancel</button>
        <button className="btn btn-primary" disabled={!amt || amt <= 0} onClick={() => onCollect(Number(amt))}>
          <WIcons.Check size={16} /> Confirm {TKn(amt || 0)}
        </button>
      </>}>
      <div className="center mb-4">
        <div className="muted small">Remaining due</div>
        <div style={{ fontSize: 34, fontWeight: 800, color: 'var(--danger)' }}>{TKn(sale.due)}</div>
        <div className="muted tiny">{sale.custName}</div>
      </div>
      <label className="field">
        <span className="lbl">Amount collected <span className="req">*</span></span>
        <input className="input" type="number" value={amt} max={sale.due} onChange={e => setAmt(e.target.value)} />
      </label>
      <button className="btn btn-secondary btn-sm mb-4" onClick={() => setAmt(sale.due)}>Pay in full ({TKn(sale.due)})</button>
      <label className="field">
        <span className="lbl">Date</span>
        <input className="input" type="date" defaultValue="2026-06-02" />
      </label>
      <label className="field" style={{ marginBottom: 0 }}>
        <span className="lbl">Notes</span>
        <textarea className="textarea" placeholder="Optional note…" value={note} onChange={e => setNote(e.target.value)} />
      </label>
    </Modal>
  );
}

// ---- tiny donut chart ----
function Donut({ data, size = 140 }) {
  const total = data.reduce((a, d) => a + d.value, 0);
  const r = size / 2 - 14, cx = size / 2, cy = size / 2, C = 2 * Math.PI * r;
  let offset = 0;
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      <circle cx={cx} cy={cy} r={r} fill="none" stroke="#EEF1F4" strokeWidth="16" />
      {data.map((d, i) => {
        const frac = d.value / total;
        const dash = frac * C;
        const el = (
          <circle key={i} cx={cx} cy={cy} r={r} fill="none" stroke={d.color} strokeWidth="16"
            strokeDasharray={`${dash} ${C - dash}`} strokeDashoffset={-offset}
            transform={`rotate(-90 ${cx} ${cy})`} strokeLinecap="butt" />
        );
        offset += dash;
        return el;
      })}
      <text x={cx} y={cy - 2} textAnchor="middle" fontSize="22" fontWeight="700" fill="#0F1E35">{total}%</text>
      <text x={cx} y={cy + 16} textAnchor="middle" fontSize="10" fill="#667085">total</text>
    </svg>
  );
}

// ---- line chart ----
function LineChart({ data, height = 160 }) {
  const w = 600, h = height, pad = 20;
  const max = Math.max(...data, 1);
  const step = (w - pad * 2) / (data.length - 1);
  const pts = data.map((v, i) => [pad + i * step, h - pad - (v / max) * (h - pad * 2)]);
  const path = pts.map((p, i) => (i === 0 ? 'M' : 'L') + p[0] + ' ' + p[1]).join(' ');
  const area = path + ` L${pts[pts.length - 1][0]} ${h - pad} L${pts[0][0]} ${h - pad} Z`;
  return (
    <svg className="line-chart" viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="none">
      <path d={area} fill="rgba(26,107,114,0.10)" />
      <path d={path} fill="none" stroke="var(--primary)" strokeWidth="2.5" />
      {pts.map((p, i) => <circle key={i} cx={p[0]} cy={p[1]} r="3" fill="var(--primary)" />)}
    </svg>
  );
}

// ================= Sidebar =================
function Sidebar({ route, go, t, collapsed }) {
  const dueCount = SALES.filter(s => s.due > 0).length;
  const extraPending = EMPTY_RETURNS.filter(e => e.type === 'extra' && e.status === 'pending').length;
  const eodPending = ALLOCATIONS.some(a => !a.reconciled);
  const items = [
    { key: 'dashboard', label: t('nav_dashboard'), icon: WIcons.Home },
    { key: 'sales/new', label: t('nav_newsale'), icon: WIcons.PlusCircle, primary: true },
    { key: 'sales', label: t('nav_sales'), icon: WIcons.Receipt },
    { key: 'dues', label: t('nav_dues'), icon: WIcons.AlertCircle, badge: dueCount || null },
    { key: 'customers', label: t('nav_customers'), icon: WIcons.Users },
    { key: 'empties', label: t('nav_empties'), icon: WIcons.Package, badge: extraPending || null, amber: true },
    { key: 'eod', label: t('nav_eod'), icon: WIcons.Moon, badge: eodPending ? '!' : null, amber: true },
    { key: 'reports', label: t('nav_reports'), icon: WIcons.BarChart },
  ];
  const isActive = (key) => {
    if (key === 'sales') return route === 'sales' || route.startsWith('sales/') && route !== 'sales/new';
    if (key === 'customers') return route === 'customers' || route.startsWith('customers/');
    return route === key;
  };
  return (
    <aside className="sidebar">
      <div className="sb-brand">
        <span className="sb-mark"><WIcons.Flame size={20} /></span>
        <span className="brand-text">
          CylinderHub
          <div className="sub">{t('portal')}</div>
        </span>
      </div>
      <nav className="sb-nav">
        {items.map(it => (
          <button key={it.key}
            className={`sb-link ${it.primary ? 'sb-newsale' : ''} ${isActive(it.key) ? 'active' : ''}`}
            onClick={() => go(it.key)} title={it.label}>
            <it.icon size={19} />
            <span className="lbl">{it.label}</span>
            {it.badge && <span className={`sb-badge ${it.amber ? 'amber' : ''}`}>{it.badge}</span>}
          </button>
        ))}
        <div className="sb-divider" />
        <button className={`sb-link ${route === 'settings' ? 'active' : ''}`} onClick={() => go('settings')} title={t('nav_settings')}>
          <WIcons.Settings size={19} /><span className="lbl">{t('nav_settings')}</span>
        </button>
      </nav>
      <div className="sb-user">
        <span className="sb-avatar">{WEB_SALESMAN.avatar}</span>
        <div className="who">
          <div className="nm">{WEB_SALESMAN.name}</div>
          <div className="rl">{WEB_SALESMAN.role}</div>
        </div>
        <button className="sb-logout" title={t('logout')} onClick={() => go('login')}><WIcons.LogOut size={18} /></button>
      </div>
    </aside>
  );
}

// ================= Topbar =================
const CRUMB_LABELS = {
  dashboard: 'Dashboard', 'sales/new': 'New Sale', sales: 'Sales History',
  dues: 'Outstanding Dues', customers: 'Customers', empties: 'Empty Cylinders',
  eod: 'End of Day', reports: 'My Reports', settings: 'Settings',
};
function Topbar({ route, go, t, lang, setLang, onToggleSidebar }) {
  const [showNotif, setShowNotif] = useState(false);
  const unread = NOTIFICATIONS.filter(n => n.unread).length;
  let crumbs = [];
  if (route.startsWith('sales/') && route !== 'sales/new') {
    crumbs = [{ label: 'Sales History', to: 'sales' }, { label: 'Sale #' + route.split('/')[1], here: true }];
  } else if (route.startsWith('customers/')) {
    const c = customerById(route.split('/')[1]);
    crumbs = [{ label: 'Customers', to: 'customers' }, { label: c ? c.name : 'Customer', here: true }];
  } else {
    crumbs = [{ label: CRUMB_LABELS[route] || 'Dashboard', here: true }];
  }
  const dateStr = new Date('2026-06-02').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' });
  return (
    <header className="topbar">
      <button className="menu-btn" onClick={onToggleSidebar} title="Toggle sidebar"><WIcons.Grid size={18} /></button>
      <div className="crumbs">
        {crumbs.map((c, i) => (
          <React.Fragment key={i}>
            {i > 0 && <WIcons.ChevronRight size={13} />}
            {c.here ? <span className="here">{c.label}</span> : <a onClick={() => go(c.to)} style={{ cursor: 'pointer' }}>{c.label}</a>}
          </React.Fragment>
        ))}
      </div>
      <div className="right">
        <span className="date">{dateStr}</span>
        <div className="lang-toggle">
          <button className={lang === 'en' ? 'on' : ''} onClick={() => setLang('en')}>EN</button>
          <button className={lang === 'bn' ? 'on' : ''} onClick={() => setLang('bn')}>BN</button>
        </div>
        <div style={{ position: 'relative' }}>
          <button className="icon-btn" onClick={() => setShowNotif(s => !s)}>
            <WIcons.Bell size={19} />
            {unread > 0 && <span className="dot-badge">{unread}</span>}
          </button>
          {showNotif && (
            <>
              <div style={{ position: 'fixed', inset: 0, zIndex: 70 }} onClick={() => setShowNotif(false)} />
              <div className="card" style={{ position: 'absolute', right: 0, top: 46, width: 320, zIndex: 80, boxShadow: 'var(--shadow-lg)' }}>
                <div className="card-head"><h3>Notifications</h3></div>
                <div>
                  {NOTIFICATIONS.map(n => (
                    <div key={n.id} style={{ display: 'flex', gap: 10, padding: '12px 16px', borderBottom: '1px solid var(--border-soft)', background: n.unread ? 'var(--teal-light)' : '#fff' }}>
                      <WIcons.Bell size={16} style={{ color: 'var(--primary)', flex: 'none', marginTop: 2 }} />
                      <div><div className="small">{n.text}</div><div className="dim tiny mt-2">{n.time}</div></div>
                    </div>
                  ))}
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  );
}

Object.assign(window, {
  WIcons, TKn, CylAva, CylRow, StatusBadge, StatCard, Modal, ToastProvider, useToast,
  EmptyState, Pagination, useSort, Th, CollectModal, Donut, LineChart, Sidebar, Topbar,
});
