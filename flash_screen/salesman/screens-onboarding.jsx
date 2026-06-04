// ============ Salesman — Splash + Onboarding ============
// Drop-in flow that precedes <Login>. Reuses app.css component kit + Icons.
const { useState, useEffect, useRef } = React;
const ObIc = window.Icons;

// —— local i18n (kept here so we don't touch sdata STR) ——
const OB = {
  tagline:   ['Salesman · Field App',        'সেলসম্যান · ফিল্ড অ্যাপ'],
  loading:   ['Loading your route…',          'আপনার রুট লোড হচ্ছে…'],
  skip:      ['Skip',                         'এড়িয়ে যান'],
  next:      ['Next',                         'পরবর্তী'],
  start:     ['Get Started',                  'শুরু করুন'],
  s1t:       ['Sell in seconds',              'সেকেন্ডে বিক্রি'],
  s1d:       ['Log a cylinder sale on the doorstep — pick the cylinder, set the quantity, take cash, due or partial.',
              'দরজায় দাঁড়িয়েই সিলিন্ডার বিক্রি লিখুন — সিলিন্ডার বাছুন, পরিমাণ দিন, ক্যাশ, বাকি বা আংশিক নিন।'],
  s2t:       ['Track every cylinder',         'প্রতিটি সিলিন্ডার ট্র্যাক'],
  s2d:       ['See your daily allocation, how much stock is left and the empties you bring back — always in sync.',
              'আজকের বরাদ্দ, কত স্টক বাকি আর ফেরত আনা খালি সিলিন্ডার — সবসময় সিঙ্কে।'],
  s3t:       ['Collect dues, close the day', 'বাকি আদায়, দিন শেষ'],
  s3d:       ['Chase outstanding payments and hand over your cash with a clean end-of-day reconciliation.',
              'বকেয়া আদায় করুন আর দিন শেষে পরিষ্কার হিসাব মিলিয়ে ক্যাশ জমা দিন।'],
};

function LangPill({ lang, setLang, onDark }) {
  return (
    <div className="lang-toggle" style={onDark ? {} : { background: 'var(--line-2)' }}>
      <button className={lang === 0 ? 'on' : ''} onClick={() => setLang(0)}
        style={onDark ? {} : { color: lang === 0 ? '#2546E0' : 'var(--text-3)' }}>EN</button>
      <button className={lang === 1 ? 'on' : ''} onClick={() => setLang(1)}
        style={onDark ? {} : { color: lang === 1 ? '#2546E0' : 'var(--text-3)' }}>বাং</button>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Splash
// ─────────────────────────────────────────────────────────────
function Splash({ onDone, lang, setLang }) {
  useEffect(() => {
    const id = setTimeout(onDone, 2300);
    return () => clearTimeout(id);
  }, []);
  return (
    <div className="sm-root ob-splash" onClick={onDone}
      style={{ background: 'linear-gradient(160deg,#3D6BFF 0%,#6C4DF6 100%)', cursor: 'pointer' }}>
      {/* decorative blooms */}
      <div className="ob-bloom" style={{ width: 320, height: 320, top: -120, right: -110 }}></div>
      <div className="ob-bloom" style={{ width: 240, height: 240, bottom: 40, left: -90 }}></div>

      <div style={{ position: 'absolute', top: 'var(--hdr-pad-top)', right: 16, zIndex: 5 }}
        onClick={(e) => e.stopPropagation()}>
        <LangPill lang={lang} setLang={setLang} onDark />
      </div>

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 18, position: 'relative', zIndex: 2 }}>
        <div className="ob-logo">
          <div className="ob-logo-glow"></div>
          <div style={{ width: 92, height: 92, borderRadius: 28, background: 'rgba(255,255,255,0.22)', display: 'inline-flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 16px 40px rgba(0,0,0,0.28), inset 0 1px 1px rgba(255,255,255,0.4)', position: 'relative', zIndex: 1 }}>
            <ObIc.Flame size={50} style={{ color: '#fff' }} />
          </div>
        </div>
        <div className="ob-fade-up" style={{ textAlign: 'center' }}>
          <div style={{ color: '#fff', fontSize: 34, fontWeight: 800, letterSpacing: '-0.025em' }}>
            Cylinder<span style={{ color: '#CFE0FF' }}>Hub</span>
          </div>
          <div style={{ color: 'rgba(255,255,255,0.85)', fontSize: 14.5, fontWeight: 600, marginTop: 5 }}>
            {OB.tagline[lang]}
          </div>
        </div>
      </div>

      <div className="ob-fade-up" style={{ paddingBottom: 54, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14, position: 'relative', zIndex: 2 }}>
        <div className="ob-dots-load">
          <span></span><span></span><span></span>
        </div>
        <div style={{ color: 'rgba(255,255,255,0.7)', fontSize: 12.5, fontWeight: 600 }}>{OB.loading[lang]}</div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Slide artwork — composed from the app's own component kit
// ─────────────────────────────────────────────────────────────
function ArtSell() {
  return (
    <div className="ob-art" style={{ '--g1': '#3D6BFF', '--g2': '#6C4DF6' }}>
      <div className="ob-card ob-float-a" style={{ width: 250, padding: 14 }}>
        <div className="lrow" style={{ padding: '2px 0 12px' }}>
          <span className="cyl-ava" style={{ '--cyl-c1': '#2E5BFF', '--cyl-c2': '#1E40D8' }}>12</span>
          <div className="grow">
            <div className="t1" style={{ whiteSpace: 'nowrap' }}>LPG 12kg</div>
            <div className="t2" style={{ whiteSpace: 'nowrap' }}>৳1,450 / pc</div>
          </div>
          <span className="pill green"><ObIc.Check size={12} /> Cash</span>
        </div>
        <div className="stepper">
          <button><ObIc.Minus size={20} /></button>
          <div className="val">2</div>
          <button style={{ background: 'var(--blue)', color: '#fff' }}><ObIc.Plus size={20} /></button>
        </div>
      </div>
      <div className="ob-badge ob-float-b" style={{ background: 'linear-gradient(150deg,#28B866,#138A40)' }}>
        <ObIc.ShoppingCart size={26} style={{ color: '#fff' }} />
      </div>
    </div>
  );
}

function ArtTrack() {
  return (
    <div className="ob-art" style={{ '--g1': '#16C7B8', '--g2': '#0E8FA0' }}>
      <div className="ob-stack ob-float-a" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, width: 228 }}>
        <div className="cstat blue" style={{ minHeight: 92, padding: 12 }}>
          <span className="ico"><ObIc.Package size={17} /></span>
          <div className="num" style={{ fontSize: 21, marginTop: 10 }}>19</div>
          <div className="lbl">Sold today</div>
        </div>
        <div className="cstat mint" style={{ minHeight: 92, padding: 12 }}>
          <span className="ico"><ObIc.Box size={17} /></span>
          <div className="num" style={{ fontSize: 21, marginTop: 10 }}>15</div>
          <div className="lbl">Left in van</div>
        </div>
      </div>
      <div className="ob-card ob-float-c" style={{ width: 214, padding: '12px 14px' }}>
        <div className="row between" style={{ marginBottom: 2 }}>
          <div className="t2" style={{ fontWeight: 700, color: 'var(--text-1)', whiteSpace: 'nowrap' }}>LPG 12kg</div>
          <div style={{ fontSize: 13, fontWeight: 800 }}>7 <span className="dim" style={{ fontWeight: 600 }}>left</span></div>
        </div>
        <div className="alloc-bar"><div style={{ width: '62%' }}></div></div>
      </div>
      <div className="ob-badge ob-float-b" style={{ background: 'linear-gradient(150deg,#16C7B8,#009E90)' }}>
        <ObIc.RotateCcw size={26} style={{ color: '#fff' }} />
      </div>
    </div>
  );
}

function ArtCollect() {
  return (
    <div className="ob-art" style={{ '--g1': '#FF8A4B', '--g2': '#F2563E' }}>
      <div className="ob-hero ob-float-a">
        <div className="lbl"><ObIc.Wallet size={14} /> Cash in hand</div>
        <div className="num">৳18,420</div>
        <div className="foot">
          <div className="col"><div className="k">Profit</div><div className="v">৳2,140</div></div>
          <div className="col"><div className="k">Collected</div><div className="v">৳9,600</div></div>
        </div>
      </div>
      <div className="ob-card ob-float-c" style={{ width: 214, padding: '10px 12px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <span className="avatar" style={{ background: '#FF7A45', width: 36, height: 36, fontSize: 13 }}>KT</span>
        <div className="grow">
          <div className="t1" style={{ fontSize: 13.5 }}>Karim Tea Stall</div>
          <div className="t2" style={{ fontSize: 11.5 }}>Due · ৳1,450</div>
        </div>
        <span className="btn btn-green btn-sm" style={{ height: 32, fontSize: 12.5, padding: '0 12px', borderRadius: 9 }}>Collect</span>
      </div>
      <div className="ob-badge ob-float-b" style={{ background: 'linear-gradient(150deg,#FF8A5B,#F2632E)' }}>
        <ObIc.Receipt size={26} style={{ color: '#fff' }} />
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Onboarding carousel
// ─────────────────────────────────────────────────────────────
function Onboarding({ onDone, lang, setLang }) {
  const [i, setI] = useState(0);
  const slides = [
    { Art: ArtSell,    title: OB.s1t[lang], desc: OB.s1d[lang] },
    { Art: ArtTrack,   title: OB.s2t[lang], desc: OB.s2d[lang] },
    { Art: ArtCollect, title: OB.s3t[lang], desc: OB.s3d[lang] },
  ];
  const last = i === slides.length - 1;
  const Art = slides[i].Art;

  return (
    <div className="sm-root" style={{ background: 'var(--bg)' }}>
      {/* top bar: skip + lang */}
      <div style={{ paddingTop: 'var(--hdr-pad-top)', padding: 'var(--hdr-pad-top) 20px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flex: 'none' }}>
        <LangPill lang={lang} setLang={setLang} />
        <button onClick={onDone} style={{ color: 'var(--text-3)', fontSize: 14, fontWeight: 700, padding: 6 }}>
          {OB.skip[lang]}
        </button>
      </div>

      {/* artwork */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: 0, padding: '8px 12px' }}>
        <div key={i} className="ob-slide-in" style={{ width: '100%', display: 'flex', justifyContent: 'center' }}>
          <Art />
        </div>
      </div>

      {/* copy + controls */}
      <div style={{ flex: 'none', padding: '0 26px 44px' }}>
        <div key={'c' + i} className="ob-slide-in">
          <h2 style={{ margin: '0 0 10px', fontSize: 27, fontWeight: 800, letterSpacing: '-0.025em', color: 'var(--text-1)', textWrap: 'pretty' }}>
            {slides[i].title}
          </h2>
          <p style={{ margin: 0, fontSize: 15.5, lineHeight: 1.5, color: 'var(--text-2)', textWrap: 'pretty', minHeight: 70 }}>
            {slides[i].desc}
          </p>
        </div>

        <div className="row between" style={{ marginTop: 26 }}>
          <div className="ob-pdots">
            {slides.map((_, k) => (
              <span key={k} className={k === i ? 'on' : ''} onClick={() => setI(k)}></span>
            ))}
          </div>
          <button className="btn btn-primary" style={{ paddingInline: last ? 24 : 22, whiteSpace: 'nowrap' }}
            onClick={() => last ? onDone() : setI(i + 1)}>
            {last ? OB.start[lang] : OB.next[lang]} <ObIc.ArrowRight size={18} />
          </button>
        </div>
      </div>
    </div>
  );
}

window.Splash = Splash;
window.Onboarding = Onboarding;
