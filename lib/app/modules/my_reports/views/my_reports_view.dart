import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/my_reports_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Obx(() => VibrantAppBar(
          title: TranslationKeys.myReports.tr,
          sub: controller.isFilterApplied.value 
              ? '${TranslationKeys.filter.tr}: ${controller.formattedDateRange}' 
              : 'Performance for ${controller.formattedDateRange}',
          accent: AppColors.reportsGradient,
          curve: true,
          onBack: () => Get.back(),
          onReset: controller.isFilterApplied.value ? controller.resetFilter : null,
          onFilter: () => _showFilterBottomSheet(context),
        )),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAllData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(context, TranslationKeys.keyMetrics.tr, Icons.speed),
                const SizedBox(height: 12),
                _buildKpiGrid(),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.dailyRevenue.tr, Icons.insights),
                const SizedBox(height: 12),
                _buildRevenueChart(context),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.paymentTypes.tr, Icons.pie_chart),
                const SizedBox(height: 12),
                _buildPaymentDonut(context),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.allocation.tr, Icons.bar_chart),
                const SizedBox(height: 12),
                _buildAllocationBarChart(context),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.performanceSummary.tr, Icons.star_border),
                const SizedBox(height: 12),
                _buildPerformanceList(context),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.cylinderFlow.tr, Icons.swap_horiz),
                const SizedBox(height: 12),
                _buildCylinderFlowTable(context),
                const SizedBox(height: 20),
                _buildSectionLabel(context, TranslationKeys.todaysReturns.tr, Icons.receipt_long),
                const SizedBox(height: 12),
                _buildDailyCollections(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: context.lineColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.filter.tr,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                if (controller.isFilterApplied.value)
                  TextButton.icon(
                    onPressed: () {
                      controller.resetFilter();
                      Get.back();
                    },
                    icon: const Icon(Icons.refresh, size: 18, color: AppColors.blue),
                    label: Text(TranslationKeys.resetFilter.tr, 
                        style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _filterCardOption(context, TranslationKeys.today.tr, 'Today', Icons.today),
            _filterCardOption(context, TranslationKeys.thisWeek.tr, 'Week', Icons.calendar_view_week),
            _filterCardOption(context, TranslationKeys.thisMonth.tr, 'Month', Icons.calendar_month),
            _filterCardOption(context, TranslationKeys.thisYear.tr, 'Year', Icons.event_note),
            _filterCardOption(context, TranslationKeys.customDate.tr, 'Custom', Icons.date_range),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _filterCardOption(BuildContext context, String label, String value, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedPeriod.value == value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () async {
            if (value == 'Custom') {
              final picked = await showDateRangePicker(
                context: Get.context!,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                helpText: TranslationKeys.selectDateRange.tr,
              );
              if (picked != null) {
                controller.changePeriod(value, from: picked.start, to: picked.end);
                Get.back();
              }
            } else {
              controller.changePeriod(value);
              Get.back();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue.withValues(alpha: 0.1) : context.lineColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? AppColors.blue : context.text3Color, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.blue : context.text2Color,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.blue, size: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildKpiGrid() {
    final r = controller.report.value;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _kpiCard(TranslationKeys.revenue.tr, '৳${NumberFormat("#,###").format(r?.totalRevenue ?? 0)}',
            AppColors.vibrantBlueGradient, Icons.attach_money),
        _kpiCard(TranslationKeys.cashCollected.tr, '৳${NumberFormat("#,###").format(r?.totalCashCollected ?? 0)}',
            AppColors.mintGradient, Icons.payments),
        _kpiCard(TranslationKeys.totalSold.tr, '${r?.totalSold ?? 0} pcs',
            AppColors.reportsGradient, Icons.shopping_bag),
        _kpiCard(TranslationKeys.due.tr, '৳${NumberFormat("#,###").format(r?.stillOutstanding ?? 0)}',
            AppColors.orangeGradient, Icons.pending_actions),
      ],
    );
  }

  Widget _kpiCard(String label, String value, LinearGradient gradient, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.15), size: 60),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final spots = controller.dailyRevenueSpots;
    if (spots.isEmpty) {
      return _emptyCard(context, TranslationKeys.noData.tr);
    }
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.lineColor),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 10),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              maxY: controller.maxRevenue,
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: context.lineColor, strokeWidth: 1, dashArray: [5, 5])),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (v, _) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(_compactNum(v),
                          style: TextStyle(fontSize: 10, color: context.text3Color, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          if (v.toInt() % 5 != 0) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('Day ${v.toInt() + 1}',
                                style: TextStyle(fontSize: 10, color: context.text3Color, fontWeight: FontWeight.bold)),
                          );
                        })),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.blue,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withValues(alpha: 0.3),
                        AppColors.blue.withValues(alpha: 0.0),
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
    if (sections.isEmpty) return _emptyCard(context, TranslationKeys.noData.tr);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.lineColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 38,
                        sectionsSpace: 2,
                        startDegreeOffset: 270,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total', 
                          style: TextStyle(
                            fontSize: 11, 
                            color: context.text3Color, 
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          )),
                        const SizedBox(height: 2),
                        Text('৳${_compactNum(controller.report.value?.totalRevenue ?? 0)}', 
                          style: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(context, TranslationKeys.cash.tr, const Color(0xFF16A34A), controller.report.value?.payBreakdown?['cash'] ?? 0),
                  _legendItem(context, TranslationKeys.partial.tr, const Color(0xFFFF7A45), controller.report.value?.payBreakdown?['partial'] ?? 0),
                  _legendItem(context, TranslationKeys.due.tr, const Color(0xFFEF4444), controller.report.value?.payBreakdown?['due'] ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color, num val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Text('${val.toInt()}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: context.text2Color)),
        ],
      ),
    );
  }

  Widget _buildAllocationBarChart(BuildContext context) {
    final bars = controller.allocationBars;
    if (bars.isEmpty) return _emptyCard(context, TranslationKeys.noData.tr);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.lineColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: bars,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final allocs = controller.report.value?.allocations;
                          if (allocs == null || v.toInt() >= allocs.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(allocs[v.toInt()].cylinder?.shortCode ?? '',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w900, color: context.text3Color)),
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
                _dotLegend('Sold', const Color(0xFF16A34A)),
                const SizedBox(width: 24),
                _dotLegend('Returned', const Color(0xFFFF7A45)),
                const SizedBox(width: 24),
                _dotLegend('Allocated', const Color(0xFFE2E8F0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dotLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPerformanceList(BuildContext context) {
    final r = controller.report.value;
    final sellThrough = (r?.sellThroughRate ?? 0) * 100;
    final collRate = r?.collectionRatePct ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.lineColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            _performanceRow(context, 'Sell-through Rate', sellThrough, AppColors.blue, Icons.trending_up),
            _divider(context),
            _performanceRow(context, 'Collection Rate', collRate, AppColors.green, Icons.account_balance_wallet),
            _divider(context),
            _performanceRow(context, 'Customer Reach', 
                (r?.customersReached ?? 0).toDouble(), AppColors.orange, Icons.people, isPct: false, max: 50),
          ],
        ),
      ),
    );
  }

  Widget _performanceRow(BuildContext context, String label, double val, Color color, IconData icon,
      {bool isPct = true, double max = 100}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Text(isPct ? '${val.toStringAsFixed(1)}%' : '${val.toInt()}',
                  style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: constraints.maxWidth * (val / max),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCylinderFlowTable(BuildContext context) {
    final items = controller.cylinderFlow.value?.byCylinder;
    if (items == null || items.isEmpty) return _emptyCard(context, TranslationKeys.noData.tr);

    const headerStyle = TextStyle(fontWeight: FontWeight.w900, fontSize: 13);
    const centerAlign = TextAlign.center;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.lineColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              color: context.lineColor.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('Type', style: headerStyle)),
                  Expanded(flex: 2, child: Text('Alloc', textAlign: centerAlign, style: headerStyle)),
                  Expanded(flex: 2, child: Text('Sold', textAlign: centerAlign, style: headerStyle)),
                  Expanded(flex: 2, child: Text('Ret', textAlign: centerAlign, style: headerStyle)),
                  Expanded(flex: 2, child: Text('Emp', textAlign: centerAlign, style: headerStyle)),
                ],
              ),
            ),
            ...items.map((i) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.lineColor.withValues(alpha: 0.3))),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(i.cylinderSize ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
                  Expanded(flex: 2, child: Text('${i.allocated ?? 0}', textAlign: centerAlign,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
                  Expanded(flex: 2, child: Text('${i.sold ?? 0}', textAlign: centerAlign,
                      style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w900, fontSize: 13))),
                  Expanded(flex: 2, child: Text('${i.returnedUnsold ?? 0}', textAlign: centerAlign,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
                  Expanded(flex: 2, child: Text('${i.emptiesCollected ?? 0}', textAlign: centerAlign,
                      style: const TextStyle(color: Color(0xFFFF7A45), fontWeight: FontWeight.w900, fontSize: 13))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCollections(BuildContext context) {
    final dc = controller.dailyCollections.value;
    if (dc == null || dc.collections == null || dc.collections!.isEmpty) {
      return _emptyCard(context, TranslationKeys.noData.tr);
    }

    return Column(
      children: dc.collections!.map((c) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.lineColor),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet, color: AppColors.green, size: 20),
            ),
            title: Text(c.customer?.name ?? TranslationKeys.walkIn.tr, 
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Sale #${c.sale?.id ?? "-"} • ${c.collectionDate}', 
                  style: TextStyle(fontSize: 12, color: context.text3Color, fontWeight: FontWeight.w500)),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('৳${NumberFormat("#,###").format(c.amount)}',
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.green, fontSize: 17)),
                const Text('Collected', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.green)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.text3Color),
        const SizedBox(width: 8),
        Text(text.toUpperCase(),
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: context.text3Color,
                letterSpacing: 1.2)),
      ],
    );
  }

  Widget _emptyCard(BuildContext context, String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: context.lineColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.query_stats, color: context.text3Color.withValues(alpha: 0.5), size: 48),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: context.text3Color, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Try adjusting your filters', style: TextStyle(color: context.text3Color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) =>
      Divider(height: 1, color: context.lineColor.withValues(alpha: 0.5), indent: 20, endIndent: 20);

  String _compactNum(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}
