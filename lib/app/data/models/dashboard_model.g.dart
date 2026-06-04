// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      salesman: json['salesman'] == null
          ? null
          : User.fromJson(json['salesman'] as Map<String, dynamic>),
      todaySales: (json['today_sales'] as List<dynamic>?)
          ?.map((e) => Sale.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: json['stats'] == null
          ? null
          : DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      pendingCollections: (json['pending_collections'] as List<dynamic>?)
          ?.map((e) => DueCollection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'salesman': instance.salesman?.toJson(),
      'today_sales': instance.todaySales?.map((e) => e.toJson()).toList(),
      'stats': instance.stats?.toJson(),
      'pending_collections': instance.pendingCollections
          ?.map((e) => e.toJson())
          .toList(),
    };

DashboardStats _$DashboardStatsFromJson(
  Map<String, dynamic> json,
) => DashboardStats(
  totalAllocated: (json['total_allocated'] as num).toInt(),
  totalSold: (json['total_sold'] as num).toInt(),
  totalReturned: (json['total_returned'] as num).toInt(),
  totalRemaining: (json['total_remaining'] as num).toInt(),
  cashCollected: (json['cash_collected'] as num).toDouble(),
  todayTotalSalesAmount: (json['today_total_sales_amount'] as num).toDouble(),
  todayDueAmount: (json['today_due_amount'] as num).toDouble(),
  pendingDueCollections: (json['pending_due_collections'] as num).toDouble(),
  totalCashToHandIn: (json['total_cash_to_hand_in'] as num).toDouble(),
  totalOutstandingDues: (json['total_outstanding_dues'] as num).toDouble(),
  todayProfit: (json['today_profit'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'total_allocated': instance.totalAllocated,
      'total_sold': instance.totalSold,
      'total_returned': instance.totalReturned,
      'total_remaining': instance.totalRemaining,
      'cash_collected': instance.cashCollected,
      'today_total_sales_amount': instance.todayTotalSalesAmount,
      'today_due_amount': instance.todayDueAmount,
      'pending_due_collections': instance.pendingDueCollections,
      'total_cash_to_hand_in': instance.totalCashToHandIn,
      'total_outstanding_dues': instance.totalOutstandingDues,
      'today_profit': instance.todayProfit,
    };
