import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cylinder_flow_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CylinderFlowResponse extends Equatable {
  final ReportPeriod? period;
  final CylinderFlowSummary? summary;
  @JsonKey(name: 'by_salesman')
  final List<CylinderFlowSalesman>? bySalesman;
  @JsonKey(name: 'by_cylinder')
  final List<CylinderFlowItem>? byCylinder;

  const CylinderFlowResponse({
    this.period,
    this.summary,
    this.bySalesman,
    this.byCylinder,
  });

  factory CylinderFlowResponse.fromJson(Map<String, dynamic> json) =>
      _$CylinderFlowResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderFlowResponseToJson(this);

  @override
  List<Object?> get props => [period, summary, bySalesman, byCylinder];
}

@JsonSerializable(explicitToJson: true)
class ReportPeriod extends Equatable {
  final String? from;
  final String? to;

  const ReportPeriod({this.from, this.to});

  factory ReportPeriod.fromJson(Map<String, dynamic> json) =>
      _$ReportPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$ReportPeriodToJson(this);

  @override
  List<Object?> get props => [from, to];
}

@JsonSerializable(explicitToJson: true)
class CylinderFlowSummary extends Equatable {
  @JsonKey(name: 'total_allocated', fromJson: _toInt)
  final int? totalAllocated;
  @JsonKey(name: 'total_sold', fromJson: _toInt)
  final int? totalSold;
  @JsonKey(name: 'total_returned_unsold', fromJson: _toInt)
  final int? totalReturnedUnsold;
  @JsonKey(name: 'total_with_salesman', fromJson: _toInt)
  final int? totalWithSalesman;
  @JsonKey(name: 'total_empties_collected', fromJson: _toInt)
  final int? totalEmptiesCollected;
  @JsonKey(name: 'total_empties_extra', fromJson: _toInt)
  final int? totalEmptiesExtra;
  @JsonKey(name: 'total_empties_normal', fromJson: _toInt)
  final int? totalEmptiesNormal;

  const CylinderFlowSummary({
    this.totalAllocated,
    this.totalSold,
    this.totalReturnedUnsold,
    this.totalWithSalesman,
    this.totalEmptiesCollected,
    this.totalEmptiesExtra,
    this.totalEmptiesNormal,
  });

  factory CylinderFlowSummary.fromJson(Map<String, dynamic> json) =>
      _$CylinderFlowSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderFlowSummaryToJson(this);

  @override
  List<Object?> get props => [
        totalAllocated,
        totalSold,
        totalReturnedUnsold,
        totalWithSalesman,
        totalEmptiesCollected,
        totalEmptiesExtra,
        totalEmptiesNormal,
      ];
}

@JsonSerializable(explicitToJson: true)
class CylinderFlowSalesman extends Equatable {
  @JsonKey(name: 'salesman_id', fromJson: _toInt)
  final int? salesmanId;
  @JsonKey(name: 'salesman_name')
  final String? salesmanName;
  @JsonKey(fromJson: _toInt)
  final int? allocated;
  @JsonKey(fromJson: _toInt)
  final int? sold;
  @JsonKey(name: 'returned_unsold', fromJson: _toInt)
  final int? returnedUnsold;
  @JsonKey(name: 'with_salesman', fromJson: _toInt)
  final int? withSalesman;
  @JsonKey(name: 'empties_collected', fromJson: _toInt)
  final int? emptiesCollected;
  @JsonKey(name: 'sell_through_rate', fromJson: _toDouble)
  final double? sellThroughRate;

  const CylinderFlowSalesman({
    this.salesmanId,
    this.salesmanName,
    this.allocated,
    this.sold,
    this.returnedUnsold,
    this.withSalesman,
    this.emptiesCollected,
    this.sellThroughRate,
  });

  factory CylinderFlowSalesman.fromJson(Map<String, dynamic> json) =>
      _$CylinderFlowSalesmanFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderFlowSalesmanToJson(this);

  @override
  List<Object?> get props => [
        salesmanId,
        salesmanName,
        allocated,
        sold,
        returnedUnsold,
        withSalesman,
        emptiesCollected,
        sellThroughRate,
      ];
}

@JsonSerializable(explicitToJson: true)
class CylinderFlowItem extends Equatable {
  @JsonKey(name: 'cylinder_id', fromJson: _toInt)
  final int? cylinderId;
  @JsonKey(name: 'cylinder_name')
  final String? cylinderName;
  @JsonKey(name: 'cylinder_size')
  final String? cylinderSize;
  @JsonKey(fromJson: _toInt)
  final int? allocated;
  @JsonKey(fromJson: _toInt)
  final int? sold;
  @JsonKey(name: 'returned_unsold', fromJson: _toInt)
  final int? returnedUnsold;
  @JsonKey(name: 'with_salesmen', fromJson: _toInt)
  final int? withSalesmen;
  @JsonKey(name: 'empties_collected', fromJson: _toInt)
  final int? emptiesCollected;
  @JsonKey(name: 'sell_through_pct', fromJson: _toDouble)
  final double? sellThroughPct;

  const CylinderFlowItem({
    this.cylinderId,
    this.cylinderName,
    this.cylinderSize,
    this.allocated,
    this.sold,
    this.returnedUnsold,
    this.withSalesmen,
    this.emptiesCollected,
    this.sellThroughPct,
  });

  factory CylinderFlowItem.fromJson(Map<String, dynamic> json) =>
      _$CylinderFlowItemFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderFlowItemToJson(this);

  @override
  List<Object?> get props => [
        cylinderId,
        cylinderName,
        cylinderSize,
        allocated,
        sold,
        returnedUnsold,
        withSalesmen,
        emptiesCollected,
        sellThroughPct,
      ];
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}
