import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cylinder_model.g.dart';

@JsonSerializable()
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

@JsonSerializable()
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
