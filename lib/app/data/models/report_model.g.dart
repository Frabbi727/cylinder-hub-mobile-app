// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesmanReport _$SalesmanReportFromJson(Map<String, dynamic> json) =>
    SalesmanReport(
      salesman: json['salesman'] == null
          ? null
          : User.fromJson(json['salesman'] as Map<String, dynamic>),
      period: json['period'] == null
          ? null
          : ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      totalAllocated: _toInt(json['total_allocated']),
      totalSold: _toInt(json['total_sold']),
      totalReturned: _toInt(json['total_returned']),
      totalRevenue: _toDouble(json['total_revenue']),
      totalCashCollected: _toDouble(json['total_cash_collected']),
      totalDuesCreated: _toDouble(json['total_dues_created']),
      totalDuesCollected: _toDouble(json['total_dues_collected']),
      stillOutstanding: _toDouble(json['still_outstanding']),
      collectionRatePct: _toDouble(json['collection_rate_pct']),
      customersReached: _toInt(json['customers_reached']),
      sellThroughRate: _toDouble(json['sell_through_rate']),
      payBreakdown: (json['pay_breakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, _toInt(e)),
      ),
      dailyRevenue: (json['daily_revenue'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, _toDouble(e)),
      ),
      sales: (json['sales'] as List<dynamic>?)
          ?.map((e) => Sale.fromJson(e as Map<String, dynamic>))
          .toList(),
      allocations: (json['allocations'] as List<dynamic>?)
          ?.map((e) => Allocation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesmanReportToJson(SalesmanReport instance) =>
    <String, dynamic>{
      'salesman': instance.salesman?.toJson(),
      'period': instance.period?.toJson(),
      'total_allocated': instance.totalAllocated,
      'total_sold': instance.totalSold,
      'total_returned': instance.totalReturned,
      'total_revenue': instance.totalRevenue,
      'total_cash_collected': instance.totalCashCollected,
      'total_dues_created': instance.totalDuesCreated,
      'total_dues_collected': instance.totalDuesCollected,
      'still_outstanding': instance.stillOutstanding,
      'collection_rate_pct': instance.collectionRatePct,
      'customers_reached': instance.customersReached,
      'sell_through_rate': instance.sellThroughRate,
      'pay_breakdown': instance.payBreakdown,
      'daily_revenue': instance.dailyRevenue,
      'sales': instance.sales?.map((e) => e.toJson()).toList(),
      'allocations': instance.allocations?.map((e) => e.toJson()).toList(),
    };

ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) =>
    ReportPeriod(from: json['from'] as String, to: json['to'] as String);

Map<String, dynamic> _$ReportPeriodToJson(ReportPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};
