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
      totalAllocated: (json['total_allocated'] as num).toInt(),
      totalSold: (json['total_sold'] as num).toInt(),
      totalReturned: (json['total_returned'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalCashCollected: (json['total_cash_collected'] as num).toDouble(),
      totalDuesCreated: (json['total_dues_created'] as num).toDouble(),
      totalDuesCollected: (json['total_dues_collected'] as num).toDouble(),
      stillOutstanding: (json['still_outstanding'] as num).toDouble(),
      collectionRatePct: (json['collection_rate_pct'] as num).toDouble(),
      customersReached: (json['customers_reached'] as num).toInt(),
      sellThroughRate: (json['sell_through_rate'] as num).toDouble(),
      payBreakdown: (json['pay_breakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      dailyRevenue: (json['daily_revenue'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
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
