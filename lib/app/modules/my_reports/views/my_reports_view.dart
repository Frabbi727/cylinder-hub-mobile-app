import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/my_reports_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

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
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          _buildPeriodTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.fetchReport,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Key Metrics'),
                      const SizedBox(height: 10),
                      _buildKpiGrid(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Revenue Trend'),
                      const SizedBox(height: 10),
                      _buildRevenueChart(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Payment Breakdown'),
                      const SizedBox(height: 10),
                      _buildPaymentChart(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Financial Summary'),
                      const SizedBox(height: 10),
                      _buildFinancialCard(),
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

  Widget _buildPeriodTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.line2Light,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _tabOption('Week', 'This Week'),
          _tabOption('Month', 'This Month'),
        ],
      ),
    );
  }

  Widget _tabOption(String value, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedPeriod.value == value;
        return GestureDetector(
          onTap: () => controller.changePeriod(value),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: isSelected
                  ? [const BoxShadow(color: AppColors.black15, blurRadius: 2, offset: Offset(0, 1))]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.mintInk : AppColors.text2Light,
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
        _kpiCard('Allocated', '${r?.totalAllocated ?? 0} pcs', AppColors.vibrantBlueGradient),
        _kpiCard('Sold', '${r?.totalSold ?? 0} pcs', AppColors.mintGradient),
        _kpiCard('Sell-through', '${((r?.sellThroughRate ?? 0) * 100).toStringAsFixed(1)}%', AppColors.reportsGradient),
        _kpiCard('Collection Rate', '${(r?.collectionRatePct ?? 0).toStringAsFixed(1)}%', AppColors.orangeGradient),
        _kpiCard('Customers', '${r?.customersReached ?? 0}', AppColors.homeGradient),
        _kpiCard('Returned', '${r?.totalReturned ?? 0} pcs', AppColors.historyGradient),
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
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final spots = controller.dailyRevenueSpots;
    if (spots.isEmpty) {
      return _emptyChartPlaceholder('No revenue data for this period');
    }
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.3;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY == 0 ? 100 : maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: AppColors.lineLight, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 46,
                    getTitlesWidget: (v, _) => Text(
                      '৳${_compactNum(v)}',
                      style: const TextStyle(fontSize: 10, color: AppColors.text3Light),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: const Color(0xFF2E5BFF),
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (p0, p1, p2, p3) =>
                        FlDotCirclePainter(radius: 3, color: const Color(0xFF2E5BFF), strokeWidth: 0),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [const Color(0xFF2E5BFF).withValues(alpha: 0.2), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map((s) => LineTooltipItem(
                            '৳${s.y.toStringAsFixed(0)}',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentChart() {
    final bars = controller.payBreakdownBars;
    if (bars.isEmpty) {
      return _emptyChartPlaceholder('No payment data for this period');
    }
    final labels = ['Cash', 'Partial', 'Due'];
    final colors = [AppColors.green, AppColors.orange, AppColors.red];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: controller.maxBarValue,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(color: AppColors.lineLight, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, g2, rod, r2) => BarTooltipItem(
                        '${rod.toY.toInt()} sales',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[v.toInt()],
                              style: const TextStyle(fontSize: 11, color: AppColors.text2Light, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: AppColors.text3Light),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: bars,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(labels[i], style: const TextStyle(fontSize: 12, color: AppColors.text2Light)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard() {
    final r = controller.report.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _finRow('Total Revenue', '৳${(r?.totalRevenue ?? 0).toStringAsFixed(0)}', bold: true),
            _divider(),
            _finRow('Cash Collected', '৳${(r?.totalCashCollected ?? 0).toStringAsFixed(0)}', color: AppColors.green),
            _divider(),
            _finRow('Dues Created', '৳${(r?.totalDuesCreated ?? 0).toStringAsFixed(0)}', color: AppColors.orange),
            _divider(),
            _finRow('Dues Collected', '৳${(r?.totalDuesCollected ?? 0).toStringAsFixed(0)}', color: AppColors.blue),
            _divider(),
            _finRow('Still Outstanding', '৳${(r?.stillOutstanding ?? 0).toStringAsFixed(0)}',
                color: (r?.stillOutstanding ?? 0) > 0 ? AppColors.red : AppColors.green, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _finRow(String label, String value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.text2Light, fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                fontSize: bold ? 16 : 15,
                color: color,
              )),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: AppColors.lineLight);

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text3Light, letterSpacing: 0.05),
    );
  }

  Widget _emptyChartPlaceholder(String message) {
    return Card(
      child: SizedBox(
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bar_chart, color: AppColors.text3Light, size: 32),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: AppColors.text3Light, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  String _compactNum(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }
}
