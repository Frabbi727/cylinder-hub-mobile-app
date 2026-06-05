import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../repository/my_reports_repository.dart';
import '../../../data/models/report_model.dart';
import 'package:fl_chart/fl_chart.dart';

class MyReportsController extends BaseController {
  final MyReportsRepository repository;
  final _authService = Get.find<AuthService>();

  final report = Rxn<SalesmanReport>();
  final selectedPeriod = 'Month'.obs;
  String _fromDate = '';
  String _toDate = '';

  MyReportsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _recalcDates();
    fetchReport();
  }

  void _recalcDates() {
    final now = DateTime.now();
    _toDate = DateFormat('yyyy-MM-dd').format(now);
    if (selectedPeriod.value == 'Week') {
      final monday = now.subtract(Duration(days: now.weekday - 1));
      _fromDate = DateFormat('yyyy-MM-dd').format(monday);
    } else {
      _fromDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    _recalcDates();
    fetchReport();
  }

  Future<void> fetchReport() async {
    final userId = _authService.user.value?.id;
    if (userId == null) return;
    showLoading();
    try {
      final response = await repository.getReport(userId, from: _fromDate, to: _toDate);
      if (response.success && response.data != null) {
        report.value = response.data;
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  List<FlSpot> get dailyRevenueSpots {
    final daily = report.value?.dailyRevenue;
    if (daily == null || daily.isEmpty) return [];
    final sorted = daily.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();
  }

  List<BarChartGroupData> get payBreakdownBars {
    final breakdown = report.value?.payBreakdown;
    if (breakdown == null) return [];
    final labels = ['cash', 'partial', 'due'];
    final colors = [const Color(0xFF4CAF50), const Color(0xFFFF9800), const Color(0xFFF44336)];
    return labels.asMap().entries.map((e) {
      final count = (breakdown[e.value] ?? 0).toDouble();
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: count,
            color: colors[e.key],
            width: 28,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    }).toList();
  }

  double get maxBarValue {
    final breakdown = report.value?.payBreakdown;
    if (breakdown == null || breakdown.isEmpty) return 10;
    return (breakdown.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.3).ceilToDouble();
  }
}
