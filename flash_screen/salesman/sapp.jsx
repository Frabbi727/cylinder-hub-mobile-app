// ============ Salesman — app root ============
const { useState, useEffect, useRef, Fragment } = React;
function App() {
  const [authed, setAuthed] = useState(false);
  const [route, setRoute] = useState('home');
  const [lang, setLangState] = useState(0);
  const [theme, setThemeState] = useState(getTheme());
  const [collectDue, setCollectDue] = useState(null);
  const [activeCust, setActiveCust] = useState(null);
  const [toast, setToast] = useState(null);
  const [dues, setDues] = useState(MY_DUES);
  const toastTimer = useRef(null);

  const setLang = (i) => { setLangIdx(i); setLangState(i); };
  const setTheme = (v) => { setThemeVal(v); setThemeState(v); };

  const showToast = (msg) => {
    setToast(msg);
    clearTimeout(toastTimer.current);
    toastTimer.current = setTimeout(() => setToast(null), 2600);
  };

  const go = (r) => { setRoute(r); };
  const openCust = (c) => { setActiveCust(c); setRoute('customerDetail'); };

  const collect = (due, amt) => {
    setDues((prev) => prev
      .map((d) => d.id === due.id ? { ...d, due: d.due - amt } : d)
      .filter((d) => d.due > 0));
    setCollectDue(null);
    showToast(t('paymentCollected'));
  };

  const ctx = { theme, setTheme };

  if (!authed) {
    return (
      <window.ThemeCtx.Provider value={ctx}>
        <Centered>
          <IOSDevice dark width={402} height={874}>
            <div data-theme={theme} style={{ display: 'contents' }}>
              <Login onLogin={() => { setAuthed(true); setRoute('home'); }} lang={lang} setLang={setLang} />
            </div>
          </IOSDevice>
        </Centered>
      </window.ThemeCtx.Provider>
    );
  }

  let screen;
  if (route === 'home')         screen = <MyDay go={go} lang={lang} setLang={setLang} />;
  else if (route === 'history') screen = <History lang={lang} setLang={setLang} />;
  else if (route === 'sell')    screen = <NewSale go={go} lang={lang} setLang={setLang} onDone={(m) => { showToast(m); setRoute('home'); }} />;
  else if (route === 'dues')    screen = <Dues lang={lang} setLang={setLang} onCollect={setCollectDue} dues={dues} />;
  else if (route === 'more')    screen = <More go={go} lang={lang} setLang={setLang} onLogout={() => { setAuthed(false); setRoute('home'); }} />;
  else if (route === 'profile') screen = <Profile go={go} lang={lang} setLang={setLang} onLogout={() => { setAuthed(false); setRoute('home'); }} />;
  else if (route === 'customers') screen = <Customers go={go} lang={lang} setLang={setLang} onOpen={openCust} />;
  else if (route === 'customerDetail') screen = <CustomerDetail cust={activeCust} go={go} lang={lang} setLang={setLang} onCollect={setCollectDue} />;
  else if (route === 'empties') screen = <Empties go={go} lang={lang} setLang={setLang} onDone={(m) => { showToast(m); setRoute('more'); }} />;
  else if (route === 'reports') screen = <Reports go={go} lang={lang} setLang={setLang} />;
  else if (route === 'eod')     screen = <EndOfDay go={go} lang={lang} setLang={setLang} onDone={() => { showToast(lang === 1 ? 'অ্যাডমিনে জমা হয়েছে ✓' : 'Day submitted to admin ✓'); setRoute('home'); }} />;

  // tab highlight: sub-screens still light up their parent tab
  const tabFor = { customerDetail: 'more', customers: 'more', empties: 'more', reports: 'more', profile: 'more', eod: 'more' };
  const navRoute = tabFor[route] || route;
  const showNav = route !== 'eod' && route !== 'sell';

  return (
    <window.ThemeCtx.Provider value={ctx}>
      <Centered>
        <IOSDevice dark width={402} height={874}>
          <div className="sm-root" data-theme={theme}>
            {screen}
            {showNav && <BotNav route={navRoute} go={go} />}
            {collectDue && <CollectSheet due={collectDue} onClose={() => setCollectDue(null)} onConfirm={(amt) => collect(collectDue, amt)} />}
            <Toast msg={toast} />
          </div>
        </IOSDevice>
      </Centered>
    </window.ThemeCtx.Provider>
  );
}

function Centered({ children }) {
  return (
    <div style={{
      minHeight: '100vh', width: '100%',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: 28, boxSizing: 'border-box',
      background: 'radial-gradient(120% 90% at 50% 0%, #232a44 0%, #131726 55%, #0b0e18 100%)',
    }}>
      {children}
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
