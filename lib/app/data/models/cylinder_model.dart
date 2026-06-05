import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cylinder_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Cylinder extends Equatable {
  final int id;
  final String name;
  final String size;
  @JsonKey(name: 'short_code')
  final String? shortCode;
  final String? color1;
  final String? color2;
  @JsonKey(name: 'reorder_level')
  final int? reorderLevel;
  final int? capacity;
  final String? status;
  final CylinderStock? stock;

  const Cylinder({
    required this.id,
    required this.name,
    required this.size,
    this.shortCode,
    this.color1,
    this.color2,
    this.reorderLevel,
    this.capacity,
    this.status,
    this.stock,
  });

  factory Cylinder.fromJson(Map<String, dynamic> json) => _$CylinderFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderToJson(this);

  @override
  List<Object?> get props => [id, name, size, shortCode, color1, color2, reorderLevel, capacity, status, stock];
}

@JsonSerializable(explicitToJson: true)
class CylinderStock extends Equatable {
  @JsonKey(name: 'filled_qty')
  final int filledQty;
  @JsonKey(name: 'empty_qty')
  final int emptyQty;
  final int? capacity;

  const CylinderStock({
    required this.filledQty,
    required this.emptyQty,
    this.capacity,
  });

  factory CylinderStock.fromJson(Map<String, dynamic> json) => _$CylinderStockFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderStockToJson(this);

  @override
  List<Object?> get props => [filledQty, emptyQty, capacity];
}

double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
