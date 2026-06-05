import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/my_reports_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'My Reports',
            sub: 'Personal performance overview',
            accent: AppColors.reportsGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          _buildPeriodTabs(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.fetchAllData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(context, 'Key Metrics'),
                      const SizedBox(height: 10),
                      _buildKpiGrid(),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Daily Revenue Trend'),
                      const SizedBox(height: 10),
                      _buildRevenueChart(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Payment Types'),
                      const SizedBox(height: 10),
                      _buildPaymentDonut(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Cylinder Allocation'),
                      const SizedBox(height: 10),
                      _buildAllocationBarChart(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Performance Summary'),
                      const SizedBox(height: 10),
                      _buildPerformanceList(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Cylinder Flow'),
                      const SizedBox(height: 10),
                      _buildCylinderFlowTable(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Today\'s Collections'),
                      const SizedBox(height: 10),
                      _buildDailyCollections(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTabs(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.line2Color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _tabOption(context, 'Week', 'This Week'),
          _tabOption(context, 'Month', 'This Month'),
        ],
      ),
    );
  }

  Widget _tabOption(BuildContext context, String value, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedPeriod.value == value;
        return GestureDetector(
          onTap: () => controller.changePeriod(value),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? context.surfaceColor : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.06),
                          blurRadius: 2,
                          offset: const Offset(0, 1))
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.mintInk : context.text2Color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKpiGrid() {
    final r = controller.report.value;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        _kpiCard('Revenue', '৳${_compactNum(r?.totalRevenue ?? 0)}',
            AppColors.vibrantBlueGradient),
        _kpiCard('Cash Collected', '৳${_compactNum(r?.totalCashCollected ?? 0)}',
            AppColors.mintGradient),
        _kpiCard('Units Sold', '${r?.totalSold ?? 0} pcs',
            AppColors.reportsGradient),
        _kpiCard('Outstanding', '৳${_compactNum(r?.stillOutstanding ?? 0)}',
            AppColors.orangeGradient),
      ],
    );
  }

  Widget _kpiCard(String label, String value, LinearGradient gradient) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final spots = controller.dailyRevenueSpots;
    if (spots.isEmpty) {
      return _emptyCard(context, 'No revenue data for this period');
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              maxY: controller.maxRevenue,
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: context.lineColor, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (v, _) => Text('৳${_compactNum(v)}',
                        style:
                            TextStyle(fontSize: 10, color: context.text3Color)),
                  ),
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                            (v.toInt() % 5 == 0) ? '${v.toInt() + 1}' : '',
                            style: TextStyle(
                                fontSize: 10, color: context.text3Color)))),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withValues(alpha: 0.2),
                        Colors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDonut(BuildContext context) {
    final sections = controller.paymentTypeSections;
    if (sections.isEmpty) return _emptyCard(context, 'No payment data');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                children: [
                  _legendItem('Cash', const Color(0xFF16A34A)),
                  _legendItem('Partial', const Color(0xFFFF7A45)),
                  _legendItem('Due', const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAllocationBarChart(BuildContext context) {
    final bars = controller.allocationBars;
    if (bars.isEmpty) return _emptyCard(context, 'No allocations found');

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: bars,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final allocs = controller.report.value?.allocations;
                          if (allocs == null || v.toInt() >= allocs.length) {
                            return const Text('');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(allocs[v.toInt()].cylinder?.size ?? '',
                                style: TextStyle(
                                    fontSize: 9, color: context.text3Color)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem('Sold', const Color(0xFF16A34A)),
                const SizedBox(width: 20),
                _legendItem('Returned', const Color(0xFFFF7A45)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceList(BuildContext context) {
    final r = controller.report.value;
    final sellThrough = (r?.sellThroughRate ?? 0) * 100;
    final collRate = r?.collectionRatePct ?? 0;

    return Card(
      child: Column(
        children: [
          _performanceRow(context, 'Sell-through Rate', sellThrough, AppColors.blue),
          _performanceRow(context, 'Collection Rate', collRate, AppColors.green),
          _performanceRow(context, 'Customer Reach', 
              (r?.customersReached ?? 0).toDouble(), AppColors.orange, isPct: false, max: 50),
        ],
      ),
    );
  }

  Widget _performanceRow(BuildContext context, String label, double val, Color color,
      {bool isPct = true, double max = 100}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(isPct ? '${val.toStringAsFixed(1)}%' : '${val.toInt()}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val / max,
              backgroundColor: context.lineColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCylinderFlowTable(BuildContext context) {
    final items = controller.cylinderFlow.value?.byCylinder;
    if (items == null || items.isEmpty) return _emptyCard(context, 'No flow data');

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Alloc')),
            DataColumn(label: Text('Sold')),
            DataColumn(label: Text('Ret')),
            DataColumn(label: Text('Emp')),
          ],
          rows: items.map((i) {
            return DataRow(cells: [
              DataCell(Text(i.cylinderSize ?? '-')),
              DataCell(Text('${i.allocated ?? 0}')),
              DataCell(Text('${i.sold ?? 0}')),
              DataCell(Text('${i.returnedUnsold ?? 0}')),
              DataCell(Text('${i.emptiesCollected ?? 0}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDailyCollections(BuildContext context) {
    final dc = controller.dailyCollections.value;
    if (dc == null || dc.collections == null || dc.collections!.isEmpty) {
      return _emptyCard(context, 'No collections today');
    }

    return Column(
      children: dc.collections!.map((c) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.wallet)),
            title: Text(c.customer?.name ?? 'Walk-in'),
            subtitle: Text('Sale #${c.sale?.id ?? "-"} · ${c.collectionDate}'),
            trailing: Text('৳${c.amount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.green)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(text.toUpperCase(),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: context.text3Color,
            letterSpacing: 0.5));
  }

  Widget _emptyCard(BuildContext context, String msg) {
    return Card(
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(msg, style: TextStyle(color: context.text3Color)),
      ),
    );
  }

  String _compactNum(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}
