import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cylinder_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Cylinder extends Equatable {
  final int id;
  @JsonKey(fromJson: _toString)
  final String name;
  @JsonKey(fromJson: _toString)
  final String size;
  @JsonKey(name: 'short_code', fromJson: _toStringNull)
  final String? shortCode;
  @JsonKey(fromJson: _toStringNull)
  final String? color1;
  @JsonKey(fromJson: _toStringNull)
  final String? color2;
  @JsonKey(name: 'reorder_level', fromJson: _toIntNull)
  final int? reorderLevel;
  @JsonKey(fromJson: _toIntNull)
  final int? capacity;
  @JsonKey(fromJson: _toStringNull)
  final String? status;
  final CylinderStock? stock;

  const Cylinder({
    required this.id,
    this.name = '',
    this.size = '',
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
  @JsonKey(name: 'filled_qty', fromJson: _toInt)
  final int filledQty;
  @JsonKey(name: 'empty_qty', fromJson: _toInt)
  final int emptyQty;
  @JsonKey(fromJson: _toIntNull)
  final int? capacity;

  const CylinderStock({
    this.filledQty = 0,
    this.emptyQty = 0,
    this.capacity,
  });

  factory CylinderStock.fromJson(Map<String, dynamic> json) => _$CylinderStockFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderStockToJson(this);

  @override
  List<Object?> get props => [filledQty, emptyQty, capacity];
}

String _toString(dynamic v) => v?.toString() ?? '';
String? _toStringNull(dynamic v) => v?.toString();
double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
