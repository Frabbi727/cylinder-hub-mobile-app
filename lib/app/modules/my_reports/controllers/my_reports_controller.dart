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

  List<double> get aggregatedRevenueData {
    final daily = report.value?.dailyRevenue;
    if (daily == null || daily.isEmpty) return [];

    switch (selectedPeriod.value) {
      case 'Today':
        final now = DateTime.now();
        final dateStr = DateFormat('yyyy-MM-dd').format(now);
        return [daily[dateStr] ?? 0.0];

      case 'Week':
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final data = <double>[];
        for (int i = 0; i < 7; i++) {
          final date = monday.add(Duration(days: i));
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          data.add(daily[dateStr] ?? 0.0);
        }
        return data;

      case 'Month':
        // Aggregate by week of the month
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);
        final data = List.filled(5, 0.0); // Max 5 partial/full weeks
        
        daily.forEach((dateStr, val) {
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.month == now.month && date.year == now.year) {
            final weekNum = ((date.day - 1) / 7).floor();
            if (weekNum < 5) data[weekNum] += val;
          }
        });
        return data;

      case 'Year':
        final now = DateTime.now();
        final data = List.filled(12, 0.0);
        daily.forEach((dateStr, val) {
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.year == now.year) {
            data[date.month - 1] += val;
          }
        });
        return data;

      case 'Custom':
        if (customFromDate.value == null || customToDate.value == null) return [];
        final data = <double>[];
        for (var date = customFromDate.value!;
            date.isBefore(customToDate.value!.add(const Duration(days: 1)));
            date = date.add(const Duration(days: 1))) {
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          data.add(daily[dateStr] ?? 0.0);
        }
        return data;

      default:
        return [];
    }
  }

  List<String> get revenueLabels {
    switch (selectedPeriod.value) {
      case 'Today':
        return [DateFormat('MMM dd').format(DateTime.now())];
      case 'Week':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'Month':
        return ['W1', 'W2', 'W3', 'W4', 'W5'];
      case 'Year':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      case 'Custom':
        if (customFromDate.value == null || customToDate.value == null) return [];
        final labels = <String>[];
        for (var date = customFromDate.value!;
            date.isBefore(customToDate.value!.add(const Duration(days: 1)));
            date = date.add(const Duration(days: 1))) {
          labels.add(DateFormat('dd/MM').format(date));
        }
        return labels;
      default:
        return [];
    }
  }

  double get maxAggregatedRevenue {
    final data = aggregatedRevenueData;
    if (data.isEmpty) return 1000;
    final max = data.reduce((a, b) => a > b ? a : b);
    return max == 0 ? 1000 : max * 1.2;
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

    return breakdown.entries.where((e) => e.value > 0).map((e) {
      final pct = (e.value / total) * 100;
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: pct > 5 ? '${pct.toStringAsFixed(0)}%' : '',
        color: colors[e.key.toLowerCase()] ?? Colors.grey,
        radius: 22,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
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
}
