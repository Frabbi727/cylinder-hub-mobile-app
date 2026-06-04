// ============ CylinderHub Salesman — app data + i18n ============
// Reuses TK, CYLINDERS, cylById from src/data.jsx (loaded first).

// ---- the logged-in salesman ----
const ME = {
  name: 'Karim Uddin',
  bnName: 'করিম উদ্দিন',
  phone: '01711-203040',
  email: 'karim@cylinderhub.com',
  avatar: 'KU',
  color: '#0D7C87',
  route: 'Mirpur · Zone 4',
  joined: 'Mar 2024',
};

// ---- today's allocation (handed out by admin) ----
const MY_ALLOC = [
  { cyl: 'lpg12', alloc: 18, sold: 11, returned: 1 },
  { cyl: 'lpg35', alloc: 6,  sold: 2,  returned: 0 },
  { cyl: 'petro', alloc: 10, sold: 6,  returned: 0 },
];

// ---- default price per cylinder (per piece) ----
const PRICE = { lpg12: 1450, lpg35: 3400, petro: 210, ind45: 5200 };

// ---- today's sales feed (most recent first) ----
const MY_SALES = [
  { id: 'S-2041', time: '2:14 PM', cyl: 'lpg12', qty: 2, price: 1450, customer: 'Hotel Sonar Bangla', phone: '01710-114455', pay: 'Cash',    paid: 2900, due: 0,    empties: 2 },
  { id: 'S-2040', time: '1:38 PM', cyl: 'petro', qty: 4, price: 210,  customer: 'Rahela Store',        phone: '01818-220011', pay: 'Due',     paid: 0,    due: 840,  empties: 0 },
  { id: 'S-2039', time: '12:30 PM',cyl: 'lpg35', qty: 1, price: 3400, customer: 'Padma Restaurant',    phone: '01912-778899', pay: 'Partial', paid: 2000, due: 1400, empties: 1 },
  { id: 'S-2038', time: '11:48 AM',cyl: 'lpg12', qty: 3, price: 1450, customer: 'Nodi General Store',   phone: '01677-553311', pay: 'Cash',    paid: 4350, due: 0,    empties: 3 },
  { id: 'S-2037', time: '10:15 AM',cyl: 'petro', qty: 2, price: 210,  customer: 'Walk-in',             phone: '',             pay: 'Cash',    paid: 420,  due: 0,    empties: 0 },
  { id: 'S-2036', time: '9:32 AM', cyl: 'lpg12', qty: 1, price: 1450, customer: 'Karim Tea Stall',     phone: '01533-998822', pay: 'Due',     paid: 0,    due: 1450, empties: 1 },
];

// ---- outstanding dues (unpaid + partial), oldest first ----
const MY_DUES = [
  { id: 'S-2036', customer: 'Karim Tea Stall',  phone: '01533-998822', cyl: 'lpg12', qty: 1, total: 1450, due: 1450, age: 'Today',   pay: 'Due' },
  { id: 'S-2040', customer: 'Rahela Store',      phone: '01818-220011', cyl: 'petro', qty: 4, total: 840,  due: 840,  age: 'Today',   pay: 'Due' },
  { id: 'S-2039', customer: 'Padma Restaurant',  phone: '01912-778899', cyl: 'lpg35', qty: 1, total: 3400, due: 1400, age: 'Today',   pay: 'Partial' },
  { id: 'S-1992', customer: 'Jharna Hotel',      phone: '01744-667788', cyl: 'lpg12', qty: 5, total: 7250, due: 3250, age: '3 days',  pay: 'Partial' },
  { id: 'S-1981', customer: 'Bismillah Store',   phone: '01655-112233', cyl: 'petro', qty: 6, total: 1260, due: 1260, age: '5 days',  pay: 'Due' },
];

// ---- frequent customers (autocomplete suggestions) ----
const CUSTOMERS = [
  { name: 'Hotel Sonar Bangla', phone: '01710-114455' },
  { name: 'Padma Restaurant',   phone: '01912-778899' },
  { name: 'Rahela Store',       phone: '01818-220011' },
  { name: 'Nodi General Store', phone: '01677-553311' },
  { name: 'Karim Tea Stall',    phone: '01533-998822' },
  { name: 'Jharna Hotel',       phone: '01744-667788' },
];

// ---- customer directory (own customers only) with detail ----
const CUST_LIST = [
  { id: 'c1', name: 'Hotel Sonar Bangla', phone: '01710-114455', address: 'Mirpur 10, Block C, Dhaka', due: 0,    revenue: 48200, since: 'Jan 2025', color: '#2E5BFF' },
  { id: 'c2', name: 'Padma Restaurant',   phone: '01912-778899', address: 'Kazipara Main Road',        due: 1400, revenue: 31500, since: 'Feb 2025', color: '#7C3AED' },
  { id: 'c3', name: 'Rahela Store',       phone: '01818-220011', address: 'Shewrapara Bazar',          due: 840,  revenue: 12600, since: 'Mar 2025', color: '#00B8A9' },
  { id: 'c4', name: 'Karim Tea Stall',    phone: '01533-998822', address: 'Mirpur 11, Lane 4',         due: 1450, revenue: 9800,  since: 'Apr 2025', color: '#FF7A45' },
  { id: 'c5', name: 'Nodi General Store', phone: '01677-553311', address: 'Mirpur 2, Main Gate',       due: 0,    revenue: 22400, since: 'Jan 2025', color: '#16A34A' },
  { id: 'c6', name: 'Jharna Hotel',       phone: '01744-667788', address: 'Pallabi, Section 12',       due: 3250, revenue: 38900, since: 'Dec 2024', color: '#EC4899' },
];

// cylinder balance (pending empties) per customer
const CUST_BALANCE = {
  c1: [ { cyl: 'lpg12', sold: 14, returned: 11 }, { cyl: 'lpg35', sold: 4, returned: 4 } ],
  c2: [ { cyl: 'lpg35', sold: 9, returned: 6 } ],
  c3: [ { cyl: 'petro', sold: 18, returned: 14 } ],
  c4: [ { cyl: 'lpg12', sold: 6, returned: 4 } ],
  c5: [ { cyl: 'lpg12', sold: 10, returned: 10 } ],
  c6: [ { cyl: 'lpg12', sold: 12, returned: 7 } ],
};

// ---- empty cylinder return log ----
const EMPTIES = [
  { id: 'E-218', cyl: 'lpg12', qty: 3, date: 'Today · 2:14 PM',  customer: 'Hotel Sonar Bangla', extra: false },
  { id: 'E-217', cyl: 'petro', qty: 2, date: 'Today · 11:48 AM', customer: 'Nodi General Store', extra: false },
  { id: 'E-216', cyl: 'lpg12', qty: 1, date: 'Today · 9:32 AM',  customer: 'Karim Tea Stall',    extra: false },
  { id: 'E-210', cyl: 'lpg12', qty: 2, date: 'Yesterday',        customer: 'Old stock collection', extra: true, reason: 'old_stock', status: 'Pending' },
];
const EXTRA_REASONS = [
  ['old_stock', 'Old stock', 'পুরনো স্টক'],
  ['neighbour', 'Neighbour collection', 'প্রতিবেশী থেকে'],
  ['competitor', 'Competitor cylinder', 'প্রতিযোগীর সিলিন্ডার'],
  ['salesman_handover', 'Salesman handover', 'সেলসম্যান হস্তান্তর'],
  ['other', 'Other', 'অন্যান্য'],
];

// ---- weekly revenue for My Reports ----
const MY_WEEK = [
  { d: 'Sat', amt: 18400 }, { d: 'Sun', amt: 22100 }, { d: 'Mon', amt: 15600 },
  { d: 'Tue', amt: 28900 }, { d: 'Wed', amt: 19200 }, { d: 'Thu', amt: 24300 }, { d: 'Fri', amt: 9800 },
];

// ---- derived day totals ----
const dayTotals = () => {
  const soldUnits   = MY_ALLOC.reduce((s, a) => s + a.sold, 0);
  const allocUnits  = MY_ALLOC.reduce((s, a) => s + a.alloc, 0);
  const collected   = MY_SALES.reduce((s, x) => s + x.paid, 0);
  const dueToday     = MY_SALES.reduce((s, x) => s + x.due, 0);
  const emptiesBack = MY_SALES.reduce((s, x) => s + x.empties, 0);
  const revenue     = MY_SALES.reduce((s, x) => s + x.qty * x.price, 0);
  const profit      = Math.round(revenue * 0.17);
  const outstanding = MY_DUES.reduce((s, d) => s + d.due, 0);
  return { soldUnits, allocUnits, collected, dueToday, emptiesBack, revenue, profit, outstanding,
           cashInHand: collected, sales: MY_SALES.length };
};

// payment-type breakdown for the donut
const payBreakdown = () => {
  const by = { Cash: 0, Partial: 0, Due: 0 };
  MY_SALES.forEach((s) => { by[s.pay] = (by[s.pay] || 0) + s.qty * s.price; });
  return by;
};

// ---- i18n ----
const STR = {
  myDay:        ['My Day',            'আজকের দিন'],
  newSale:      ['New Sale',          'নতুন বিক্রয়'],
  sell:         ['Sell',              'বিক্রয়'],
  history:      ['Sales',             'বিক্রয়'],
  salesHistory: ['Sales History',     'বিক্রয়ের ইতিহাস'],
  dues:         ['Dues',              'বকেয়া'],
  outstanding:  ['Outstanding Dues',  'বকেয়া পাওনা'],
  collect:      ['Collect Payment',   'পেমেন্ট সংগ্রহ'],
  endOfDay:     ['End of Day',        'দিন শেষ'],
  profile:      ['Profile',           'প্রোফাইল'],
  goodMorning:  ['Good afternoon',    'শুভ অপরাহ্ন'],
  soldToday:    ['Sold today',        'আজ বিক্রি'],
  collected:    ['Collected',         'সংগ্রহ হয়েছে'],
  toCollect:    ['To collect',        'সংগ্রহ বাকি'],
  emptiesBack:  ['Empties back',      'খালি ফেরত'],
  myStock:      ['My stock today',    'আজকের স্টক'],
  quickActions: ['Quick actions',     'দ্রুত কাজ'],
  recentSales:  ['Recent sales',      'সাম্প্রতিক বিক্রয়'],
  viewAll:      ['View all',          'সব দেখুন'],
  ofAllocated:  ['allocated',         'বরাদ্দ'],
  left:         ['left',              'বাকি'],
  cylinder:     ['Cylinder',          'সিলিন্ডার'],
  quantity:     ['Quantity',          'পরিমাণ'],
  pricePiece:   ['Price / piece',     'দাম / পিস'],
  customer:     ['Customer',          'গ্রাহক'],
  phone:        ['Phone (optional)',  'ফোন (ঐচ্ছিক)'],
  payment:      ['Payment',           'পেমেন্ট'],
  cash:         ['Cash',              'নগদ'],
  due:          ['Due',               'বাকি'],
  partial:      ['Partial',           'আংশিক'],
  amountPaid:   ['Amount paid',       'পরিশোধিত'],
  emptiesReturned:['Empties returned','খালি ফেরত'],
  total:        ['Total',             'মোট'],
  confirmSale:  ['Confirm sale',      'বিক্রয় নিশ্চিত করুন'],
  saleRecorded: ['Sale recorded',     'বিক্রয় রেকর্ড হয়েছে'],
  search:       ['Search customer…',  'গ্রাহক খুঁজুন…'],
  all:          ['All',               'সব'],
  amountToCollect:['Amount to collect','সংগ্রহের পরিমাণ'],
  fullAmount:   ['Full amount',       'সম্পূর্ণ'],
  paymentCollected:['Payment collected','পেমেন্ট সংগৃহীত'],
  totalDue:     ['Total outstanding', 'মোট বকেয়া'],
  callCustomer: ['Call',              'কল'],
  startReconcile:['Start reconciliation','মিলকরণ শুরু'],
  reconcileDesc:['Submit your stock & cash to admin','অ্যাডমিনকে স্টক ও নগদ জমা দিন'],
  back:         ['Back',              'পেছনে'],
  next:         ['Next',              'পরবর্তী'],
  submit:       ['Submit to admin',   'অ্যাডমিনে জমা দিন'],
  login:        ['Log in',            'লগইন'],
  logout:       ['Log out',           'লগ আউট'],
  password:     ['Password',          'পাসওয়ার্ড'],
  synced:       ['All changes synced','সব সিঙ্ক হয়েছে'],
  offlineQueued:['1 sale queued — will sync when online','১টি বিক্রয় অপেক্ষমাণ — অনলাইনে সিঙ্ক হবে'],
  noDues:       ['All dues collected',  'সব বকেয়া সংগৃহীত'],
  language:     ['Language',          'ভাষা'],
};

// —— expanded strings for the redesigned + new screens ——
Object.assign(STR, {
  dashboard:    ['Dashboard',         'ড্যাশবোর্ড'],
  here:         ["Here's what's happening", 'আজকের অবস্থা'],
  goodMorningG: ['Good morning',      'শুভ সকাল'],
  goodEvening:  ['Good evening',      'শুভ সন্ধ্যা'],
  totalAllocated:['Total Allocated',  'মোট বরাদ্দ'],
  totalSold:    ['Total Sold',        'মোট বিক্রি'],
  cashCollected:['Cash Collected',    'নগদ সংগৃহীত'],
  cashInHand:   ['Cash in Hand',      'হাতে নগদ'],
  todaysProfit: ['Today\u2019s Profit','আজকের লাভ'],
  cylindersLeft:['Cylinders Left',    'সিলিন্ডার বাকি'],
  withYou:      ['with you',          'আপনার কাছে'],
  canSell:      ['can sell',          'বিক্রয়যোগ্য'],
  soldSoFar:    ['Sold so far today', 'আজ এ পর্যন্ত বিক্রি'],
  todaysPayments:['Today\u2019s payments','আজকের পেমেন্ট'],
  salesDue:     ['sales due',         'বিক্রয় বকেয়া'],
  fifoBasis:    ['FIFO basis',        'FIFO ভিত্তিতে'],
  todaysAlloc:  ['Today\u2019s Allocations','আজকের বরাদ্দ'],
  todaysSales:  ['Today\u2019s Sales','আজকের বিক্রয়'],
  seeAll:       ['See all',           'সব দেখুন'],
  noSalesYet:   ['No sales recorded yet today.','আজ কোনো বিক্রয় নেই।'],
  recordOne:    ['Record one',        'একটি যোগ করুন'],
  allocated:    ['Allocated',         'বরাদ্দ'],
  sold:         ['Sold',              'বিক্রি'],
  returned:     ['Returned',          'ফেরত'],
  done:         ['Done',              'সম্পন্ন'],
  // more / settings
  more:         ['More',              'আরও'],
  customers:    ['Customers',         'গ্রাহকগণ'],
  addCustomer:  ['Add Customer',      'গ্রাহক যোগ'],
  emptyCyl:     ['Empty Cylinders',   'খালি সিলিন্ডার'],
  myReports:    ['My Reports',        'আমার রিপোর্ট'],
  account:      ['Account',           'অ্যাকাউন্ট'],
  appearance:   ['Appearance',        'থিম'],
  lightMode:    ['Light',             'লাইট'],
  darkMode:     ['Dark',              'ডার্ক'],
  settings:     ['Settings',          'সেটিংস'],
  manage:       ['Manage your work',  'আপনার কাজ পরিচালনা'],
  // customers
  totalCustDue: ['Total Customer Due','মোট গ্রাহক বকেয়া'],
  noCustomers:  ['No customers yet',  'কোনো গ্রাহক নেই'],
  searchName:   ['Search name or phone…','নাম বা ফোন খুঁজুন…'],
  customerName: ['Customer name',     'গ্রাহকের নাম'],
  address:      ['Address (optional)','ঠিকানা (ঐচ্ছিক)'],
  save:         ['Save',              'সংরক্ষণ'],
  totalRevenue: ['Total revenue',     'মোট আয়'],
  pendingEmpties:['Pending empties',  'খালি বাকি'],
  cylBalance:   ['Cylinder Balance',  'সিলিন্ডার ব্যালেন্স'],
  recentSales2: ['Recent Sales',      'সাম্প্রতিক বিক্রয়'],
  paymentHistory:['Payment History',  'পেমেন্ট ইতিহাস'],
  collectDue:   ['Collect Due',       'বকেয়া সংগ্রহ'],
  pending:      ['pending',           'বাকি'],
  bottles:      ['bottles',           'বোতল'],
  // empties
  logEmpty:     ['Log Empty Return',  'খালি ফেরত লগ'],
  recordEmpty:  ['Record Empty Cylinders','খালি সিলিন্ডার রেকর্ড'],
  emptyQty:     ['Empty qty collected','খালি সংখ্যা'],
  normalReturn: ['Normal Return',     'সাধারণ ফেরত'],
  extraReturn:  ['Extra Return',      'অতিরিক্ত ফেরত'],
  submitReturn: ['Submit Return',     'ফেরত জমা দিন'],
  reason:       ['Reason',            'কারণ'],
  returnDate:   ['Return date',       'ফেরতের তারিখ'],
  whoReturned:  ['Customer (optional)','গ্রাহক (ঐচ্ছিক)'],
  emptyLogged:  ['Empty cylinders logged','খালি সিলিন্ডার লগ হয়েছে'],
  extraLogged:  ['Extra return — admin will verify','অতিরিক্ত ফেরত — অ্যাডমিন যাচাই করবে'],
  todaysReturns:['Today\u2019s returns','আজকের ফেরত'],
  // reports
  performance:  ['Personal performance overview','ব্যক্তিগত পারফরম্যান্স'],
  revenue:      ['Revenue',           'আয়'],
  unitsSold:    ['Units Sold',        'বিক্রিত একক'],
  outstanding2: ['Outstanding',       'বকেয়া'],
  dailyRevenue: ['Daily Sales Revenue','দৈনিক বিক্রয় আয়'],
  paymentTypes: ['Payment Types',     'পেমেন্টের ধরন'],
  perfSummary:  ['Performance Summary','পারফরম্যান্স সারাংশ'],
  sellThrough:  ['Sell-through',      'বিক্রয় হার'],
  duesCreated:  ['Dues Created',      'বকেয়া তৈরি'],
  duesCollected:['Dues Collected',    'বকেয়া সংগৃহীত'],
  collectionRate:['Collection Rate',  'সংগ্রহ হার'],
  cylFlow:      ['Cylinder Flow',     'সিলিন্ডার প্রবাহ'],
  emptiesBack2: ['Empties Back',      'খালি ফেরত'],
  thisWeek:     ['This Week',         'এই সপ্তাহ'],
  thisMonth:    ['This Month',        'এই মাস'],
  today:        ['Today',             'আজ'],
  noData:       ['No data',           'কোনো তথ্য নেই'],
});

// —— theme (light / dark) ——
const THEME_KEY = 'ch_sm_theme';
let THEME = 'light';
try { THEME = localStorage.getItem(THEME_KEY) || 'light'; } catch (e) {}

let LANG = 0; // 0 = EN, 1 = BN
const t = (k) => (STR[k] ? STR[k][LANG] : k);

Object.assign(window, {
  ME, MY_ALLOC, PRICE, MY_SALES, MY_DUES, CUSTOMERS, CUST_LIST, CUST_BALANCE,
  EMPTIES, EXTRA_REASONS, MY_WEEK, dayTotals, payBreakdown, STR, t,
  getLang: () => LANG, setLangIdx: (i) => { LANG = i; },
  getTheme: () => THEME,
  setThemeVal: (v) => { THEME = v; try { localStorage.setItem(THEME_KEY, v); } catch (e) {} },
});
