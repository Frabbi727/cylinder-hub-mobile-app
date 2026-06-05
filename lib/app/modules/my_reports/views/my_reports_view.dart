import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
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
          _buildPeriodTabs(context),
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
                      _buildSectionLabel(context, 'Key Metrics'),
                      const SizedBox(height: 10),
                      _buildKpiGrid(),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Revenue Trend'),
                      const SizedBox(height: 10),
                      _buildRevenueChart(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Payment Breakdown'),
                      const SizedBox(height: 10),
                      _buildPaymentChart(context),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'Financial Summary'),
                      const SizedBox(height: 10),
                      _buildFinancialCard(context),
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
                  ? [BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.06),
                      blurRadius: 2,
                      offset: const Offset(0, 1))]
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
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final spots = controller.dailyRevenueSpots;
    if (spots.isEmpty) {
      return _emptyChartPlaceholder(context, 'No revenue data for this period');
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
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: context.lineColor, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 46,
                    getTitlesWidget: (v, _) => Text(
                      '৳${_compactNum(v)}',
                      style: TextStyle(fontSize: 10, color: context.text3Color),
                    ),
                  ),
                ),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                        radius: 3, color: AppColors.blue, strokeWidth: 0),
                  ),
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
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map((s) => LineTooltipItem(
                            '৳${s.y.toStringAsFixed(0)}',
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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

  Widget _buildPaymentChart(BuildContext context) {
    final bars = controller.payBreakdownBars;
    if (bars.isEmpty) {
      return _emptyChartPlaceholder(context, 'No payment data for this period');
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
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: context.lineColor, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, g2, rod, r2) => BarTooltipItem(
                        '${rod.toY.toInt()} sales',
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            v.toInt() < labels.length ? labels[v.toInt()] : '',
                            style: TextStyle(
                                fontSize: 11,
                                color: context.text2Color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: TextStyle(
                              fontSize: 10, color: context.text3Color),
                        ),
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: colors[i], shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(labels[i],
                          style: TextStyle(
                              fontSize: 12, color: context.text2Color)),
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

  Widget _buildFinancialCard(BuildContext context) {
    final r = controller.report.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _finRow(context, 'Total Revenue',
                '৳${(r?.totalRevenue ?? 0).toStringAsFixed(0)}',
                bold: true),
            _divider(context),
            _finRow(context, 'Cash Collected',
                '৳${(r?.totalCashCollected ?? 0).toStringAsFixed(0)}',
                color: AppColors.green),
            _divider(context),
            _finRow(context, 'Dues Created',
                '৳${(r?.totalDuesCreated ?? 0).toStringAsFixed(0)}',
                color: AppColors.orange),
            _divider(context),
            _finRow(context, 'Dues Collected',
                '৳${(r?.totalDuesCollected ?? 0).toStringAsFixed(0)}',
                color: AppColors.blue),
            _divider(context),
            _finRow(
              context,
              'Still Outstanding',
              '৳${(r?.stillOutstanding ?? 0).toStringAsFixed(0)}',
              color: (r?.stillOutstanding ?? 0) > 0
                  ? AppColors.red
                  : AppColors.green,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _finRow(BuildContext context, String label, String value,
      {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: context.text2Color, fontWeight: FontWeight.w600)),
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

  Widget _divider(BuildContext context) =>
      Divider(height: 1, color: context.lineColor);

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.text3Color,
          letterSpacing: 0.05),
    );
  }

  Widget _emptyChartPlaceholder(BuildContext context, String message) {
    return Card(
      child: SizedBox(
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: context.text3Color, size: 32),
              const SizedBox(height: 8),
              Text(message,
                  style: TextStyle(color: context.text3Color, fontSize: 13)),
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
