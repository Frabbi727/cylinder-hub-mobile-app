import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'sale_model.dart';

part 'dashboard_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardData extends Equatable {
  final User? salesman;
  @JsonKey(name: 'today_sales')
  final List<Sale>? todaySales;
  final DashboardStats? stats;
  @JsonKey(name: 'pending_collections')
  final List<DueCollection>? pendingCollections;

  const DashboardData({
    this.salesman,
    this.todaySales,
    this.stats,
    this.pendingCollections,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);

  @override
  List<Object?> get props => [salesman, todaySales, stats, pendingCollections];
}

@JsonSerializable(explicitToJson: true)
class DashboardStats extends Equatable {
  @JsonKey(name: 'total_allocated', fromJson: _toInt)
  final int totalAllocated;
  @JsonKey(name: 'total_sold', fromJson: _toInt)
  final int totalSold;
  @JsonKey(name: 'total_returned', fromJson: _toInt)
  final int totalReturned;
  @JsonKey(name: 'total_remaining', fromJson: _toInt)
  final int totalRemaining;
  @JsonKey(name: 'cash_collected', fromJson: _toDouble)
  final double cashCollected;
  @JsonKey(name: 'today_total_sales_amount', fromJson: _toDouble)
  final double todayTotalSalesAmount;
  @JsonKey(name: 'today_due_amount', fromJson: _toDouble)
  final double todayDueAmount;
  @JsonKey(name: 'pending_due_collections', fromJson: _toDouble)
  final double pendingDueCollections;
  @JsonKey(name: 'total_cash_to_hand_in', fromJson: _toDouble)
  final double totalCashToHandIn;
  @JsonKey(name: 'total_outstanding_dues', fromJson: _toDouble)
  final double totalOutstandingDues;
  @JsonKey(name: 'today_profit', fromJson: _toDouble)
  final double todayProfit;

  const DashboardStats({
    this.totalAllocated = 0,
    this.totalSold = 0,
    this.totalReturned = 0,
    this.totalRemaining = 0,
    this.cashCollected = 0.0,
    this.todayTotalSalesAmount = 0.0,
    this.todayDueAmount = 0.0,
    this.pendingDueCollections = 0.0,
    this.totalCashToHandIn = 0.0,
    this.totalOutstandingDues = 0.0,
    this.todayProfit = 0.0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);

  @override
  List<Object?> get props => [
        totalAllocated,
        totalSold,
        totalReturned,
        totalRemaining,
        cashCollected,
        todayTotalSalesAmount,
        todayDueAmount,
        pendingDueCollections,
        totalCashToHandIn,
        totalOutstandingDues,
        todayProfit,
      ];
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return (v as num).toDouble();
}
int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return (v as num).toInt();
}
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
