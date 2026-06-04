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
  @JsonKey(name: 'total_allocated')
  final int totalAllocated;
  @JsonKey(name: 'total_sold')
  final int totalSold;
  @JsonKey(name: 'total_returned')
  final int totalReturned;
  @JsonKey(name: 'total_remaining')
  final int totalRemaining;
  @JsonKey(name: 'cash_collected')
  final double cashCollected;
  @JsonKey(name: 'today_total_sales_amount')
  final double todayTotalSalesAmount;
  @JsonKey(name: 'today_due_amount')
  final double todayDueAmount;
  @JsonKey(name: 'pending_due_collections')
  final double pendingDueCollections;
  @JsonKey(name: 'total_cash_to_hand_in')
  final double totalCashToHandIn;
  @JsonKey(name: 'total_outstanding_dues')
  final double totalOutstandingDues;
  @JsonKey(name: 'today_profit')
  final double todayProfit;

  const DashboardStats({
    required this.totalAllocated,
    required this.totalSold,
    required this.totalReturned,
    required this.totalRemaining,
    required this.cashCollected,
    required this.todayTotalSalesAmount,
    required this.todayDueAmount,
    required this.pendingDueCollections,
    required this.totalCashToHandIn,
    required this.totalOutstandingDues,
    required this.todayProfit,
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
