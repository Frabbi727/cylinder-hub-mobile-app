// ============ Salesman Web App — mock data + i18n ============
// Reuses CYLINDERS, TK, cylById from src/data.jsx (loaded first).

const WEB_SALESMAN = {
  id: 'm1', name: 'Karim Uddin', avatar: 'KU', role: 'Salesman',
  phone: '01711-203040', depot: 'Mirpur Depot',
};

// Cylinder types this salesman deals in (subset of CYLINDERS) with today's price.
const CYL_PRICE = { lpg12: 1450, lpg35: 3400, petro: 210, ind45: 5200 };

// Today's allocations for the salesman
const ALLOCATIONS = [
  { id: 'a1', cyl: 'lpg12', allocated: 24, sold: 16, returned: 0,  reconciled: false },
  { id: 'a2', cyl: 'lpg35', allocated: 10, sold: 6,  returned: 1,  reconciled: false },
  { id: 'a3', cyl: 'petro', allocated: 12, sold: 9,  returned: 2,  reconciled: true  },
];

// Customers
const CUSTOMERS = [
  { id: 'c1', name: 'Hotel Sonar Bangla', phone: '01710-100200', address: 'Mirpur 10, Dhaka', notes: 'Bulk buyer, pays weekly.' },
  { id: 'c2', name: 'Rahela Store',        phone: '01811-220330', address: 'Kazipara Bazar',   notes: '' },
  { id: 'c3', name: 'Padma Restaurant',    phone: '01913-440550', address: 'Shewrapara Main Rd', notes: 'Prefers 35kg.' },
  { id: 'c4', name: 'Nodi General Store',  phone: '01612-660770', address: 'Pirerbag',         notes: '' },
  { id: 'c5', name: 'Karim Tea Stall',     phone: '01515-880990', address: 'Mirpur 11',        notes: 'Small daily orders.' },
  { id: 'c6', name: 'Bismillah Hotel',     phone: '01717-112233', address: 'Mirpur 2',         notes: '' },
  { id: 'c7', name: 'Sabina Kitchen',      phone: '01818-334455', address: 'Monipur',          notes: 'Often returns late.' },
  { id: 'c8', name: 'Green Mart',          phone: '01919-556677', address: 'Mirpur 12',        notes: '' },
];

// Sales — datetime ISO-ish, items, paid amount. Status derived.
// daysAgo: 0 = today.
const RAW_SALES = [
  { id: 142, daysAgo: 0, time: '2:14 PM', cust: 'c1', items: [{cyl:'lpg12',qty:2}], paid: 'full' },
  { id: 141, daysAgo: 0, time: '1:02 PM', cust: 'c2', items: [{cyl:'petro',qty:4}], paid: 'none' },
  { id: 140, daysAgo: 0, time: '12:30 PM',cust: 'c3', items: [{cyl:'lpg35',qty:1}], paid: 'partial', paidAmt: 2000 },
  { id: 139, daysAgo: 0, time: '11:48 AM',cust: 'walkin', items: [{cyl:'lpg12',qty:3}], paid: 'full' },
  { id: 138, daysAgo: 0, time: '10:15 AM',cust: 'c4', items: [{cyl:'petro',qty:2}], paid: 'full' },
  { id: 137, daysAgo: 0, time: '9:40 AM', cust: 'c5', items: [{cyl:'lpg12',qty:1},{cyl:'petro',qty:1}], paid: 'none' },
  { id: 131, daysAgo: 2, time: '4:20 PM', cust: 'c6', items: [{cyl:'lpg35',qty:2}], paid: 'partial', paidAmt: 3000 },
  { id: 129, daysAgo: 3, time: '3:05 PM', cust: 'c7', items: [{cyl:'lpg12',qty:2}], paid: 'none' },
  { id: 126, daysAgo: 4, time: '11:20 AM',cust: 'c3', items: [{cyl:'lpg35',qty:1}], paid: 'full' },
  { id: 122, daysAgo: 6, time: '5:10 PM', cust: 'c2', items: [{cyl:'petro',qty:6}], paid: 'full' },
  { id: 118, daysAgo: 9, time: '1:45 PM', cust: 'c7', items: [{cyl:'lpg12',qty:3}], paid: 'none' },
  { id: 113, daysAgo: 12,time: '10:30 AM',cust: 'c8', items: [{cyl:'lpg12',qty:1}], paid: 'full' },
  { id: 108, daysAgo: 15,time: '2:50 PM', cust: 'c1', items: [{cyl:'lpg12',qty:4}], paid: 'partial', paidAmt: 4000 },
  { id: 101, daysAgo: 18,time: '9:15 AM', cust: 'c6', items: [{cyl:'lpg35',qty:1}], paid: 'full' },
];

const MS_DAY = 86400000;
function dateFromDaysAgo(d) {
  const t = new Date('2026-06-02T12:00:00');
  return new Date(t.getTime() - d * MS_DAY);
}
function fmtDate(dt) {
  return dt.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}
function fmtShortDate(dt) {
  return dt.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

// Build full sale objects
const SALES = RAW_SALES.map(s => {
  const items = s.items.map(it => ({ ...it, price: CYL_PRICE[it.cyl], total: CYL_PRICE[it.cyl] * it.qty }));
  const total = items.reduce((a, it) => a + it.total, 0);
  let paid = 0;
  if (s.paid === 'full') paid = total;
  else if (s.paid === 'partial') paid = s.paidAmt || 0;
  const due = total - paid;
  let status = due <= 0 ? 'cash' : (paid > 0 ? 'partial' : 'due');
  const dt = dateFromDaysAgo(s.daysAgo);
  const daysOverdue = due > 0 ? s.daysAgo : 0;
  const overdue = due > 0 && s.daysAgo > 7;
  // payment history
  const payments = [];
  if (paid > 0) {
    payments.push({ date: fmtDate(dt), amount: paid, by: 'Karim Uddin', note: s.paid === 'partial' ? 'Partial at sale' : 'Paid at sale' });
  }
  return {
    id: s.id, dt, time: s.time, custId: s.cust,
    custName: s.cust === 'walkin' ? 'Walk-in' : (CUSTOMERS.find(c => c.id === s.cust) || {}).name,
    items, total, paid, due, status, daysOverdue, overdue, payments,
    qty: items.reduce((a, it) => a + it.qty, 0),
  };
});

const salesById = (id) => SALES.find(s => s.id === id);
const customerById = (id) => CUSTOMERS.find(c => c.id === id);

// Customer aggregates
function customerStats(cid) {
  const cs = SALES.filter(s => s.custId === cid);
  const totalSales = cs.length;
  const totalDue = cs.reduce((a, s) => a + s.due, 0);
  const totalPurchased = cs.reduce((a, s) => a + s.total, 0);
  const totalPaid = cs.reduce((a, s) => a + s.paid, 0);
  const lastSale = cs.length ? cs.map(s => s.dt).sort((a, b) => b - a)[0] : null;
  // empties owed: total cyls bought minus returned (mock returned counts)
  const bought = cs.reduce((a, s) => a + s.qty, 0);
  const returned = EMPTY_RETURNS.filter(e => e.custId === cid).reduce((a, e) => a + e.qty, 0);
  const emptiesOwed = Math.max(0, bought - returned);
  return { totalSales, totalDue, totalPurchased, totalPaid, lastSale, emptiesOwed };
}

// Empty returns (today + history)
const EMPTY_RETURNS = [
  { id: 'e1', daysAgo: 0, time: '2:20 PM', custId: 'c1', cyl: 'lpg12', qty: 2, type: 'normal', status: 'verified', reason: '' },
  { id: 'e2', daysAgo: 0, time: '1:10 PM', custId: 'c4', cyl: 'petro', qty: 2, type: 'normal', status: 'verified', reason: '' },
  { id: 'e3', daysAgo: 0, time: '11:55 AM',custId: 'c3', cyl: 'lpg35', qty: 1, type: 'extra',  status: 'pending', reason: 'Neighbour collection' },
  { id: 'e4', daysAgo: 1, time: '4:30 PM', custId: 'c2', cyl: 'petro', qty: 3, type: 'normal', status: 'verified', reason: '' },
  { id: 'e5', daysAgo: 2, time: '10:05 AM',custId: 'c6', cyl: 'lpg35', qty: 1, type: 'extra',  status: 'verified', reason: 'Old stock' },
  { id: 'e6', daysAgo: 3, time: '3:40 PM', custId: 'c8', cyl: 'lpg12', qty: 1, type: 'normal', status: 'verified', reason: '' },
];
EMPTY_RETURNS.forEach(e => { e.dt = dateFromDaysAgo(e.daysAgo); e.custName = e.custId === 'walkin' ? 'Walk-in' : (customerById(e.custId) || {}).name; });

// Live stock snapshot (filled / empty / with-you / with-customers per type)
const STOCK_SNAP = [
  { cyl: 'lpg12', filled: 45, empty: 12, withYou: 8, withCust: 15, low: false },
  { cyl: 'lpg35', filled: 6,  empty: 3,  withYou: 4, withCust: 10, low: true  },
  { cyl: 'petro', filled: 18, empty: 5,  withYou: 1, withCust: 8,  low: false },
];
STOCK_SNAP.forEach(s => s.total = s.filled + s.empty + s.withYou + s.withCust);

// Report data — last 14 days revenue
const REPORT_DAILY = (() => {
  const arr = [];
  const base = [3200,0,4100,5600,2800,0,6200,4400,3900,5100,2600,4800,5400,6800];
  for (let i = 13; i >= 0; i--) {
    arr.push({ date: fmtShortDate(dateFromDaysAgo(i)), amt: base[13 - i] });
  }
  return arr;
})();
const REPORT_PAY = [
  { label: 'Cash', value: 62, color: '#176B3A' },
  { label: 'Partial', value: 24, color: '#A85200' },
  { label: 'Due', value: 14, color: '#B83030' },
];
const REPORT_EMPTIES = [4, 2, 5, 3, 6, 1, 4, 3, 5, 2, 4, 6, 3, 7];

const NOTIFICATIONS = [
  { id: 'n1', text: 'Reconcile Petromax allocation before 7 PM', time: '10m ago', unread: true },
  { id: 'n2', text: 'Admin approved your extra empty return (35kg)', time: '2h ago', unread: true },
  { id: 'n3', text: 'Hotel Sonar Bangla due is now 6 days old', time: '5h ago', unread: false },
];

// ============ i18n ============
const STRINGS = {
  en: {
    nav_dashboard: 'Dashboard', nav_newsale: 'New Sale', nav_sales: 'Sales History',
    nav_dues: 'Outstanding Dues', nav_customers: 'Customers', nav_empties: 'Empty Cylinders',
    nav_eod: 'End of Day', nav_reports: 'My Reports', nav_settings: 'Settings',
    portal: 'Salesman Portal', logout: 'Logout',
    good_morning: 'Good morning', today_overview: "Here's your day at a glance",
    total_allocated: 'Total Allocated', total_sold: 'Total Sold', cash_collected: 'Cash Collected',
    outstanding_dues: 'Outstanding Dues', todays_allocations: "Today's Allocations",
    todays_sales: "Today's Sales", see_all: 'See all', record_sale: 'Record Sale',
    new_sale: 'New Sale', collect: 'Collect', view: 'View', search: 'Search',
    customer: 'Customer', amount: 'Amount', paid: 'Paid', due: 'Due', status: 'Status',
    end_of_day: 'End of Day', export_csv: 'Export CSV', add_customer: 'Add Customer',
    sold: 'Sold', allocated: 'Allocated', returned: 'Returned', with_you: 'With You',
  },
  bn: {
    nav_dashboard: 'ড্যাশবোর্ড', nav_newsale: 'নতুন বিক্রয়', nav_sales: 'বিক্রয় ইতিহাস',
    nav_dues: 'বকেয়া', nav_customers: 'গ্রাহক', nav_empties: 'খালি সিলিন্ডার',
    nav_eod: 'দিনের সমাপ্তি', nav_reports: 'আমার রিপোর্ট', nav_settings: 'সেটিংস',
    portal: 'সেলসম্যান পোর্টাল', logout: 'লগআউট',
    good_morning: 'শুভ সকাল', today_overview: 'আপনার দিনের সারসংক্ষেপ',
    total_allocated: 'মোট বরাদ্দ', total_sold: 'মোট বিক্রয়', cash_collected: 'নগদ সংগ্রহ',
    outstanding_dues: 'বকেয়া পরিমাণ', todays_allocations: 'আজকের বরাদ্দ',
    todays_sales: 'আজকের বিক্রয়', see_all: 'সব দেখুন', record_sale: 'বিক্রয় রেকর্ড',
    new_sale: 'নতুন বিক্রয়', collect: 'সংগ্রহ', view: 'দেখুন', search: 'খুঁজুন',
    customer: 'গ্রাহক', amount: 'পরিমাণ', paid: 'পরিশোধিত', due: 'বকেয়া', status: 'অবস্থা',
    end_of_day: 'দিনের সমাপ্তি', export_csv: 'CSV রপ্তানি', add_customer: 'গ্রাহক যোগ',
    sold: 'বিক্রিত', allocated: 'বরাদ্দ', returned: 'ফেরত', with_you: 'আপনার কাছে',
  },
};

Object.assign(window, {
  WEB_SALESMAN, CYL_PRICE, ALLOCATIONS, CUSTOMERS, SALES, EMPTY_RETURNS,
  STOCK_SNAP, REPORT_DAILY, REPORT_PAY, REPORT_EMPTIES, NOTIFICATIONS, STRINGS,
  salesById, customerById, customerStats, fmtDate, fmtShortDate, dateFromDaysAgo,
});
