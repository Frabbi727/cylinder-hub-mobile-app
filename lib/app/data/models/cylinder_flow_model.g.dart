// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cylinder_flow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CylinderFlowResponse _$CylinderFlowResponseFromJson(
        Map<String, dynamic> json) =>
    CylinderFlowResponse(
      period: json['period'] == null
          ? null
          : ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      summary: json['summary'] == null
          ? null
          : CylinderFlowSummary.fromJson(
              json['summary'] as Map<String, dynamic>),
      bySalesman: (json['by_salesman'] as List<dynamic>?)
          ?.map((e) => CylinderFlowSalesman.fromJson(e as Map<String, dynamic>))
          .toList(),
      byCylinder: (json['by_cylinder'] as List<dynamic>?)
          ?.map((e) => CylinderFlowItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CylinderFlowResponseToJson(
        CylinderFlowResponse instance) =>
    <String, dynamic>{
      'period': instance.period?.toJson(),
      'summary': instance.summary?.toJson(),
      'by_salesman': instance.bySalesman?.map((e) => e.toJson()).toList(),
      'by_cylinder': instance.byCylinder?.map((e) => e.toJson()).toList(),
    };

ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) => ReportPeriod(
      from: json['from'] as String?,
      to: json['to'] as String?,
    );

Map<String, dynamic> _$ReportPeriodToJson(ReportPeriod instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };

CylinderFlowSummary _$CylinderFlowSummaryFromJson(Map<String, dynamic> json) =>
    CylinderFlowSummary(
      totalAllocated: _toInt(json['total_allocated']),
      totalSold: _toInt(json['total_sold']),
      totalReturnedUnsold: _toInt(json['total_returned_unsold']),
      totalWithSalesman: _toInt(json['total_with_salesman']),
      totalEmptiesCollected: _toInt(json['total_empties_collected']),
      totalEmptiesExtra: _toInt(json['total_empties_extra']),
      totalEmptiesNormal: _toInt(json['total_empties_normal']),
    );

Map<String, dynamic> _$CylinderFlowSummaryToJson(
        CylinderFlowSummary instance) =>
    <String, dynamic>{
      'total_allocated': instance.totalAllocated,
      'total_sold': instance.totalSold,
      'total_returned_unsold': instance.totalReturnedUnsold,
      'total_with_salesman': instance.totalWithSalesman,
      'total_empties_collected': instance.totalEmptiesCollected,
      'total_empties_extra': instance.totalEmptiesExtra,
      'total_empties_normal': instance.totalEmptiesNormal,
    };

CylinderFlowSalesman _$CylinderFlowSalesmanFromJson(
        Map<String, dynamic> json) =>
    CylinderFlowSalesman(
      salesmanId: _toInt(json['salesman_id']),
      salesmanName: json['salesman_name'] as String?,
      allocated: _toInt(json['allocated']),
      sold: _toInt(json['sold']),
      returnedUnsold: _toInt(json['returned_unsold']),
      withSalesman: _toInt(json['with_salesman']),
      emptiesCollected: _toInt(json['empties_collected']),
      sellThroughRate: _toDouble(json['sell_through_rate']),
    );

Map<String, dynamic> _$CylinderFlowSalesmanToJson(
        CylinderFlowSalesman instance) =>
    <String, dynamic>{
      'salesman_id': instance.salesmanId,
      'salesman_name': instance.salesmanName,
      'allocated': instance.allocated,
      'sold': instance.sold,
      'returned_unsold': instance.returnedUnsold,
      'with_salesman': instance.withSalesman,
      'empties_collected': instance.emptiesCollected,
      'sell_through_rate': instance.sellThroughRate,
    };

CylinderFlowItem _$CylinderFlowItemFromJson(Map<String, dynamic> json) =>
    CylinderFlowItem(
      cylinderId: _toInt(json['cylinder_id']),
      cylinderName: json['cylinder_name'] as String?,
      cylinderSize: json['cylinder_size'] as String?,
      allocated: _toInt(json['allocated']),
      sold: _toInt(json['sold']),
      returnedUnsold: _toInt(json['returned_unsold']),
      withSalesmen: _toInt(json['with_salesmen']),
      emptiesCollected: _toInt(json['empties_collected']),
      sellThroughPct: _toDouble(json['sell_through_pct']),
    );

Map<String, dynamic> _$CylinderFlowItemToJson(CylinderFlowItem instance) =>
    <String, dynamic>{
      'cylinder_id': instance.cylinderId,
      'cylinder_name': instance.cylinderName,
      'cylinder_size': instance.cylinderSize,
      'allocated': instance.allocated,
      'sold': instance.sold,
      'returned_unsold': instance.returnedUnsold,
      'with_salesmen': instance.withSalesmen,
      'empties_collected': instance.emptiesCollected,
      'sell_through_pct': instance.sellThroughPct,
    };
