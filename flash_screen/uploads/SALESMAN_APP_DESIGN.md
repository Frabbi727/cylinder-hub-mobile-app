# CylinderHub — Salesman App Business & Design Guide

> For UI/UX prototyping. Covers every screen, every state, every business rule.

---

## App Overview

A salesman starts his day with cylinders allocated by admin, goes out and sells them to his customers, collects cash (sometimes partial), logs empty returns, and at end of day reconciles everything and hands over the cash.

---

## User Journey (Full Day)

```
Wake up → Open App → See Dashboard (what was allocated)
    ↓
Go to customer → New Sale → Record sale + cash collected
    ↓
Customer only pays part → Due recorded automatically
    ↓
Later customer pays due → Collect Due → Cash added to hand
    ↓
Customer returns empty bottles → Log Empty Return
    ↓
End of day → EOD → Submit sold qty + cash → Done
```

---

## Screens

```
1. Login
2. Dashboard (Home)
3. New Sale
4. Sales History
5. Sale Detail
6. Outstanding Dues
7. Customers List
8. Add Customer
9. Customer Detail
10. Empty Cylinders (log return)
11. End of Day (EOD)
12. My Reports
13. Notifications
```

---

## Screen 1 — Login

### Purpose
Salesman enters email + password to access the app.

### What to show
- App logo / name
- Email input
- Password input (with show/hide toggle)
- Login button
- Error message area

### States
| State | UI |
|-------|----|
| Default | Empty form |
| Loading | Button shows spinner, inputs disabled |
| Wrong credentials | Red error: "Invalid credentials. Check your email and password." |
| Account inactive | Red error: "Your account has been deactivated. Contact admin." |
| Success | Navigate to Dashboard |

### Business rules
- No "forgot password" — admin resets password
- Role check: only `role = salesman` should use this app (if admin logs in, show a message: "Admin accounts are not supported in this app.")
- Store both `access_token` and `refresh_token` after successful login

---

## Screen 2 — Dashboard (Home)

### Purpose
Salesman's main screen. Shows what they have for the day and today's performance.

### Sections to show

#### Header
- Greeting: "Good morning, Karim 👋"
- Today's date

#### Alert Banner (show only if needed)
- 🟡 **Overdue reconciliation**: "You have unreconciled allocations from previous days."
- 🔴 **After 7pm**: "Don't forget to complete End of Day before midnight."

#### Stat Cards (4 cards)
| Card | Value | Sub-label |
|------|-------|-----------|
| Cash in Hand | `total_cash_to_hand_in` | Sales cash + due collections |
| Today's Profit | `today_profit` | FIFO basis |
| Outstanding Dues | `total_outstanding_dues` | From your customers |
| Cylinders Left | sum of `with_salesman` across allocations | Still with you |

#### Today's Allocations
One card per cylinder type allocated today.
Each card shows:
- Cylinder name + size + color badge
- Price per unit (৳X/pcs)
- Allocated: X | Sold: X | Remaining: X
- Progress bar: sold % of allocated
- `✓ Done` badge if reconciled

#### Today's Sales (list, last 5)
- Customer name
- Cylinders sold (Omera 12 × 10)
- Total amount
- Payment badge: `CASH` / `PARTIAL` / `DUE`
- Time

#### Quick Action Buttons
- ➕ New Sale
- 💰 Collect Due
- 📦 Log Empty Return
- 🌙 End of Day

### States
| Condition | UI |
|-----------|----|
| No allocations today | Show: "No cylinders allocated for today. Contact your admin." |
| All reconciled | Show: "✅ All done for today!" green banner |
| Pending due collections | Show notification dot on "End of Day" button |

### Business rules
- `with_salesman = qty − sold_qty − returned_qty` for each allocation
- `total_cash_to_hand_in = cash_collected + pending_due_collections`
- Cash in hand increases when a due is collected → refresh dashboard

---

## Screen 3 — New Sale

### Purpose
Record a cylinder sale to a customer.

### Flow
```
Select Customer (or walk-in)
     ↓
Add cylinder items (type + qty + price)
     ↓
Choose payment type (cash / partial / due)
     ↓
Enter paid amount (if partial)
     ↓
Review order summary
     ↓
Confirm → Sale recorded
```

### Sections

#### Customer Selector
- Search bar: type name or phone → shows matching customers
- "+ Add new customer" quick option → opens inline form (name + phone)
- If walk-in: leave customer blank
- **Only shows your own customers** — other salesman's customers don't appear

#### Items Section
- Dropdown: which cylinder type (from your allocation)
- Qty input: number (min 1, max = your remaining balance for that type)
- Price: pre-filled from your allocation `sale_price` (editable)
- "Remove" button per item
- "+ Add item" for multi-item sale

#### Order Summary (live calculation)
```
Item 1: Omera 12 kg × 10 @ ৳2,400 = ৳24,000
─────────────────────────────────────────────
Total:                              ৳24,000
```

#### Payment Section
- Payment type selector: `Cash` / `Partial` / `Due`
- If **Cash**: paid = total (no input needed, show "Full payment")
- If **Partial**: show "Amount collected ৳" input field
- If **Due**: paid = 0 (show "Customer will pay later")

#### Below payment (live)
```
Total:          ৳24,000
Paid now:       ৳14,000
Remaining due:  ৳10,000  ← show in red if > 0
```

### States
| State | UI |
|-------|----|
| No cylinders left | Disable the cylinder in dropdown, show "Out of stock" |
| Qty exceeds allocation | Red error under qty input: "Only 5 remaining" |
| Wrong customer | 403 response → show "This customer is not yours" |
| Sale success | Show success screen → "Sale recorded ✅" → back to Dashboard |
| Saving | Show loading spinner on confirm button |

### Business rules
- You can only sell cylinders you have allocated (system checks balance)
- You can only sell to customers you created
- If `payment_type = cash`: do NOT send `paid_amount` in request (or send equal to total)
- If `payment_type = partial`: `paid_amount` must be > 0 and < total
- If `payment_type = due`: `paid_amount = 0`
- Multi-cylinder type sale is allowed in one transaction

---

## Screen 4 — Sales History

### Purpose
View all your past sales. Filter by date, type, dues.

### Filters
- Period tabs: Today / This Week / This Month / Custom
- Toggle: "Only with dues" — shows sales with remaining balance
- Search: customer name or phone

### List item shows
- Customer name (or "Walk-in")
- Cylinders: Omera 12 × 10, Jamuna 20 × 5
- Total amount
- Payment badge: `CASH` (green) / `PARTIAL` (amber) / `DUE` (red)
- Date

### Tap → Sale Detail screen

### Business rules
- Only your own sales appear
- `due_amount = total_amount − paid_amount` (always recalculated)
- A `partial` sale that got fully paid still shows as `cash` in payment_type

---

## Screen 5 — Sale Detail

### Purpose
Full detail of one sale. Can collect payment from here.

### Sections

#### Sale Info
- Customer name + phone
- Sale date
- Items breakdown
- Total / Paid / Remaining

#### Payment History
List of all payments collected after the original sale:
```
৳5,000 collected — Jun 4, 2026
৳3,000 collected — Jun 6, 2026
```

#### Collect Payment Button
Show only if `due_amount > 0`.
Opens payment collection form:
- Amount field (max = remaining due)
- "Pay in Full" shortcut button → fills max amount
- Date field
- Notes (optional)
- Confirm button

### States
| State | UI |
|-------|----|
| Fully paid | Show "✅ Fully paid" — hide collect button |
| Has remaining due | Show "Collect ৳X,XXX" button in red/amber |
| Amount > remaining | Error: "Amount exceeds remaining due of ৳X" |

---

## Screen 6 — Outstanding Dues

### Purpose
See which customers owe money and collect payments.

### Summary cards (top)
- Total Due Amount: ৳XX,XXX
- No. of Sales
- No. of Customers Owing
- Oldest Due: X days

### Filters
- Sort: Oldest First / Largest Amount First / Customer Name
- Filter: Only overdue > 7 days (checkbox)

### List item shows
- Customer name + phone
- Total sale amount
- Paid amount (green)
- Remaining due (red, bold)
- Sale date + age (e.g. "3d")
- `Collect` button

### Tap Collect → opens payment modal
Same as Sale Detail payment form.

### Tap row → Sale Detail

### States
| State | UI |
|-------|----|
| No dues | Show: "🎉 All dues collected! Great work." |
| Overdue > 7 days | Row background slightly red |

### Business rules
- Shows only YOUR customers' dues
- After collecting: update `Customer.total_due`, create `DueCollection` record
- Collected amount shows as `pending_due_collections` until EOD

---

## Screen 7 — Customers List

### Purpose
Browse and search your own customers.

### Search bar
- Live search by name or phone
- Results update as you type

### List item shows
- Customer name
- Phone number
- Total due (show in red if > 0, hide if 0)

### Floating "+ Add Customer" button

### Tap → Customer Detail

### States
| State | UI |
|-------|----|
| No customers | Show: "No customers yet. Add your first one." |
| Search no results | Show: "No customer found for 'X'" |

### Business rules
- You only see customers **you added**
- Another salesman's customers are invisible to you

---

## Screen 8 — Add Customer

### Purpose
Create a new customer linked to you.

### Form
- Name * (required)
- Phone (optional)
- Address (optional)
- Save button

### States
| State | UI |
|-------|----|
| Saving | Spinner on button |
| Success | Navigate to Customer Detail or back to list |
| Name missing | Red error under name field |

---

## Screen 9 — Customer Detail

### Purpose
Full profile of one customer. Their history with you.

### Sections

#### Header
- Customer name + phone + address
- Total due (red if > 0)
- Total revenue from this customer

#### Cylinder Balance
"Pending empties" — how many cylinders they haven't returned yet.
Per cylinder type:
```
Omera 12 kg:  Sold 10 · Returned 3 · Pending 7 bottles
```

#### Recent Sales
List of sales to this customer (tappable).

#### Payment History
All due collections from this customer.

---

## Screen 10 — Empty Cylinders

### Purpose
Log empty cylinder bottles returned by a customer.

### Form
- Cylinder type (dropdown)
- Qty
- Return date (default: today)
- Customer (optional — who returned)
- Is this extra/unusual? (toggle)
  - If yes: show "Reason" dropdown
- Notes (optional)
- Submit

### Extra return reasons (if `is_extra = true`)
| Option | Label |
|--------|-------|
| `old_stock` | Old stock from customer |
| `neighbour` | Collected from neighbour |
| `competitor` | Competitor's cylinder |
| `salesman_handover` | Transferred from another salesman |
| `other` | Other |

### States
| State | UI |
|-------|----|
| Normal return | Simple form |
| Extra return | Reason dropdown appears |
| Success | "Empty cylinders logged ✅" |
| Extra return pending | Show "Pending admin verification" label in list |

### Business rules
- Normal empty return (`is_extra = false`) → instantly accepted
- Extra return (`is_extra = true`) → goes to admin for verification
- `empty_qty` in warehouse increases after logging

---

## Screen 11 — End of Day (EOD)

### Purpose
Submit end-of-day reconciliation. Confirm sold qty and hand in cash.

### When to show
After the salesman has finished selling for the day. Usually evening.

### Top Summary Card — "Today's Cash Accountability"
```
From today's cylinder sales          ৳183,250
Today's dues (credit given)         ৳100,000
Pending due collections                  ৳80,000
────────────────────────────────────
Total cash to hand in               ৳263,250

⚠ Your outstanding (own customers only)  ৳100,000
```

### Allocation Cards (one per allocation)
Each card shows:
- Cylinder name + size + badge
- Price per unit
- Allocated / Sold / Remaining (To Return)
- Status: `Reconcile` button (if not reconciled) or `✅ Reconciled` badge

#### When "Reconcile" is tapped → expand inline form

**Inside reconcile form:**

**Summary row:**
```
30 Allocated  |  10 Sold  |  ৳2,400/pcs  |  ৳4,000 Customers paid  |  ৳20,000 Due given
```

**Input fields:**
```
How many did you sell? *     [  10  ]      (max: 30)
Cash submitted ৳ *          [ 14000 ]
                              Collected: ৳14,000 · Due: ৳10,000
```

**Auto calculation:**
```
[ 10 Sold ✓ ] [ 20 Return to warehouse ] [ 10 + 20 = 30 ✓ ]
```

**Buttons:** Cancel | Review & Submit →

#### Confirmation step (before final submit)
```
Confirm before submitting:

[ 10 Cylinders Sold ] [ 20 Return to Warehouse ] [ ৳14,000 Cash to Hand In ]

⚠ Cash (৳14,000) is less than expected (৳24,000).
  The difference of ৳10,000 will remain as customer dues.

⚠ This cannot be undone.

← Back     Confirm & Submit
```

### All Done Screen
When all allocations reconciled:
```
✅  All Done!
All allocations reconciled for today.

Total Sold: 90 pcs    Total Returned: 40 pcs

Cash Summary:
Cylinder sales collected    ৳183,250
Today's dues (collect later) ৳100,000
──────────────────────────────────────
Total handed in             ৳183,250
```

### Business rules
- `returned_qty = qty − sold_qty` (automatic — salesman does NOT input this)
- EOD is **irreversible** by salesman (admin only can edit)
- Pending due collections are swept automatically when any allocation is reconciled
- "Outstanding dues" warning is shown but does NOT block reconciliation
- If cash submitted < expected: difference stays as customer due (not an error)

---

## Screen 12 — My Reports

### Purpose
Personal performance summary for a period.

### Period selector
Today / This Week / This Month / Custom date range

### KPI Cards (row 1)
| Card | Value |
|------|-------|
| Revenue | Total sales amount |
| Units Sold | Total cylinders sold (pcs) |
| Cash Collected | Cash received at time of sale |
| Outstanding | Still uncollected dues |

### Charts
- **Bar chart**: Daily revenue for the period
- **Pie chart**: Payment breakdown (Cash % / Partial % / Due %)

### Performance Summary grid
| Metric | Formula | Example |
|--------|---------|---------|
| Total Allocated | From allocations | 130 pcs |
| Total Sold | From sales | 90 pcs |
| Total Returned | Unsold | 40 pcs |
| Sell-through | sold / allocated × 100 | 69.2% |
| Dues Created | revenue − cash at sale | ৳40,000 |
| Dues Collected | Payments collected later | ৳0 |
| Collection Rate | dues_collected / dues_created × 100 | 0% |

### Cylinder Flow table
Per cylinder type:
- Allocated / Sold / Returned / Empties Collected / Sell-through %

### Sales table
Full list of sales in period.

---

## Screen 13 — Notifications

### Purpose
Alerts from admin (low stock, large sale, etc.)

### List item
- Icon based on type
- Title + body text
- Time ago
- Unread = slightly highlighted background

### Mark read
- Tap individual → mark read
- "Mark all read" button

### Notification types
| Type | Meaning |
|------|---------|
| `low_stock` | A cylinder type is below reorder level |
| `large_sale` | A sale exceeded a threshold |
| `allocation` | Admin has allocated stock to you |

---

## UI State Design Rules

### Loading States
Every screen that fetches data must show a loading skeleton or spinner.

### Empty States
Every list must have a specific empty state message (not just blank screen).

### Error States
Network error → "No internet connection. Pull to refresh."  
Server error → "Something went wrong. Try again."

### Optimistic Updates
After `POST /sales`: immediately show the new sale in the list, then sync.  
After `POST /sales/{id}/pay`: immediately update the due amount shown.

### Pull to Refresh
Dashboard, Sales History, Dues — all should support pull to refresh.

---

## Color & Status Guide

### Payment Types
| Status | Color | Badge |
|--------|-------|-------|
| `cash` | Green `#176B3A` | CASH |
| `partial` | Amber `#A85200` | PARTIAL |
| `due` | Red `#B83030` | DUE |

### Due Urgency
| Days overdue | Color |
|-------------|-------|
| 0–3 days | Green |
| 3–7 days | Amber |
| 7+ days | Red |

### Allocation Status
| State | Indicator |
|-------|-----------|
| Reconciled | Green left border + ✓ badge |
| Active today | Teal left border |
| Overdue (prev day) | Red left border + ⚠ label |

---

## Data Relationships (for mobile state)

```
Salesman
 ├── Allocations (today + unreconciled past)
 │    └── Cylinder (type info)
 ├── Today's Sales
 │    ├── Customer
 │    └── Items → Cylinder
 ├── Customers (own only)
 │    ├── Sales history
 │    └── Due collections
 └── Stats
      ├── cash_collected
      ├── today_profit
      ├── total_cash_to_hand_in
      └── total_outstanding_dues
```

---

## Key Numbers to Always Show

These 4 numbers are the most important for a salesman's daily awareness:

| # | Number | Where |
|---|--------|-------|
| 1 | **Cash in Hand** (`total_cash_to_hand_in`) | Dashboard top |
| 2 | **Cylinders Left** (sum of `with_salesman`) | Dashboard top |
| 3 | **Outstanding Dues** (`total_outstanding_dues`) | Dashboard top |
| 4 | **Today's Profit** (`today_profit`) | Dashboard top |

---

## Calculation Reference

```
due_amount            = total_amount − paid_amount
with_salesman         = qty − sold_qty − returned_qty
sold_pct              = (sold_qty / qty) × 100
cash_in_hand          = cash_collected + pending_due_collections
total_cash_to_hand_in = salesCashToday + pendingDueCollections
sell_through          = total_sold / total_allocated × 100
collection_rate       = dues_collected / dues_created × 100
pending_qty (empties) = sold_qty_to_customer − returned_qty_by_customer
```

---

## What Salesman CANNOT Do (Design Blockers)

| Action | Why blocked | What to show |
|--------|-------------|-------------|
| See another salesman's customers | Data isolation | Don't show. Search returns empty. |
| Sell to another salesman's customer | Business rule | Error: "This customer is not yours" |
| Sell more than allocated | Stock control | Error: "Only X remaining" |
| Edit a reconciled EOD | Final | Show read-only, no edit button |
| Delete a sale | Admin only | No delete button in salesman app |
| Edit/delete a customer | Admin only | No edit/delete button |
| See other salesmen's reports | Data isolation | Report page shows own data only |
