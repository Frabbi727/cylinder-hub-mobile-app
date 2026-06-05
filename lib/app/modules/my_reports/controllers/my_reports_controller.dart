import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/api_response.dart';
import '../repository/my_reports_repository.dart';
import '../../../data/models/report_model.dart';
import '../../../data/models/cylinder_flow_model.dart';
import '../../../data/models/daily_collection_model.dart';
import 'package:fl_chart/fl_chart.dart';

class MyReportsController extends BaseController {
  final MyReportsRepository repository;
  final _authService = Get.find<AuthService>();

  final report = Rxn<SalesmanReport>();
  final cylinderFlow = Rxn<CylinderFlowResponse>();
  final dailyCollections = Rxn<DailyCollectionResponse>();

  final selectedPeriod = 'Today'.obs;
  final customFromDate = Rxn<DateTime>();
  final customToDate = Rxn<DateTime>();
  
  final isFilterApplied = false.obs;

  String _fromDate = '';
  String _toDate = '';

  String get formattedDateRange {
    if (_fromDate.isEmpty || _toDate.isEmpty) return '';
    final from = DateTime.parse(_fromDate);
    final to = DateTime.parse(_toDate);
    
    if (selectedPeriod.value == 'Today') {
      return DateFormat('MMM dd, yyyy').format(from);
    }
    
    return '${DateFormat('MMM dd').format(from)} - ${DateFormat('MMM dd, yyyy').format(to)}';
  }

  MyReportsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _recalcDates();
    fetchAllData();
  }

  void _recalcDates() {
    final now = DateTime.now();
    _toDate = DateFormat('yyyy-MM-dd').format(now);
    
    switch (selectedPeriod.value) {
      case 'Today':
        _fromDate = _toDate;
        break;
      case 'Week':
        final monday = now.subtract(Duration(days: now.weekday - 1));
        _fromDate = DateFormat('yyyy-MM-dd').format(monday);
        break;
      case 'Month':
        _fromDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
        break;
      case 'Year':
        _fromDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, 1, 1));
        break;
      case 'Custom':
        if (customFromDate.value != null && customToDate.value != null) {
          _fromDate = DateFormat('yyyy-MM-dd').format(customFromDate.value!);
          _toDate = DateFormat('yyyy-MM-dd').format(customToDate.value!);
        } else {
          _fromDate = _toDate;
        }
        break;
    }
  }

  void changePeriod(String period, {DateTime? from, DateTime? to}) {
    selectedPeriod.value = period;
    customFromDate.value = from;
    customToDate.value = to;
    isFilterApplied.value = period != 'Today';
    _recalcDates();
    fetchAllData();
  }

  void resetFilter() {
    selectedPeriod.value = 'Today';
    customFromDate.value = null;
    customToDate.value = null;
    isFilterApplied.value = false;
    _recalcDates();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final userId = _authService.user.value?.id;
    if (userId == null) return;
    showLoading();
    try {
      final results = await Future.wait([
        repository.getReport(userId, from: _fromDate, to: _toDate),
        repository.getCylinderFlow(userId, from: _fromDate, to: _toDate),
        repository.getDailyCollections(userId,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())),
      ]);

      final reportResponse = results[0] as ApiResponse<SalesmanReport>;
      final flowResponse = results[1] as ApiResponse<CylinderFlowResponse>;
      final collectionsResponse =
          results[2] as ApiResponse<DailyCollectionResponse>;

      if (reportResponse.success) report.value = reportResponse.data;
      if (flowResponse.success) cylinderFlow.value = flowResponse.data;
      if (collectionsResponse.success) {
        dailyCollections.value = collectionsResponse.data;
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

    final from = DateTime.parse(_fromDate);
    final to = DateTime.parse(_toDate);
    final spots = <FlSpot>[];
    var index = 0.0;

    for (var date = from;
        date.isBefore(to.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final revenue = daily[dateStr] ?? 0.0;
      spots.add(FlSpot(index, revenue));
      index += 1.0;
    }
    return spots;
  }

  List<PieChartSectionData> get paymentTypeSections {
    final breakdown = report.value?.payBreakdown;
    if (breakdown == null || breakdown.isEmpty) return [];

    final total = breakdown.values.fold(0, (sum, val) => sum + val);
    if (total == 0) return [];

    final colors = {
      'cash': const Color(0xFF16A34A),
      'partial': const Color(0xFFFF7A45),
      'due': const Color(0xFFEF4444),
    };

    return breakdown.entries.map((e) {
      final pct = (e.value / total) * 100;
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: '${pct.toStringAsFixed(0)}%',
        color: colors[e.key.toLowerCase()] ?? Colors.grey,
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  List<BarChartGroupData> get allocationBars {
    final allocs = report.value?.allocations;
    if (allocs == null) return [];

    return allocs.asMap().entries.map((e) {
      final a = e.value;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: a.qty.toDouble(),
            color: const Color(0xFFE2E8F0),
            width: 20,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, a.soldQty.toDouble(), const Color(0xFF16A34A)),
              BarChartRodStackItem(a.soldQty.toDouble(),
                  (a.soldQty + a.returnedQty).toDouble(), const Color(0xFFFF7A45)),
            ],
          ),
        ],
      );
    }).toList();
  }

  double get maxRevenue {
    final spots = dailyRevenueSpots;
    if (spots.isEmpty) return 1000;
    final max = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return max == 0 ? 1000 : max * 1.2;
  }
}
