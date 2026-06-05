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

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalAllocated: json['total_allocated'] == null
          ? 0
          : _toInt(json['total_allocated']),
      totalSold: json['total_sold'] == null ? 0 : _toInt(json['total_sold']),
      totalReturned: json['total_returned'] == null
          ? 0
          : _toInt(json['total_returned']),
      totalRemaining: json['total_remaining'] == null
          ? 0
          : _toInt(json['total_remaining']),
      cashCollected: json['cash_collected'] == null
          ? 0.0
          : _toDouble(json['cash_collected']),
      todayTotalSalesAmount: json['today_total_sales_amount'] == null
          ? 0.0
          : _toDouble(json['today_total_sales_amount']),
      todayDueAmount: json['today_due_amount'] == null
          ? 0.0
          : _toDouble(json['today_due_amount']),
      pendingDueCollections: json['pending_due_collections'] == null
          ? 0.0
          : _toDouble(json['pending_due_collections']),
      totalCashToHandIn: json['total_cash_to_hand_in'] == null
          ? 0.0
          : _toDouble(json['total_cash_to_hand_in']),
      totalOutstandingDues: json['total_outstanding_dues'] == null
          ? 0.0
          : _toDouble(json['total_outstanding_dues']),
      todayProfit: json['today_profit'] == null
          ? 0.0
          : _toDouble(json['today_profit']),
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
