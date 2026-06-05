// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cylinder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cylinder _$CylinderFromJson(Map<String, dynamic> json) => Cylinder(
  id: _toInt(json['id']),
  name: json['name'] as String,
  size: json['size'] as String,
  shortCode: json['short_code'] as String?,
  color1: json['color1'] as String?,
  color2: json['color2'] as String?,
  reorderLevel: _toIntNull(json['reorder_level']),
  capacity: _toIntNull(json['capacity']),
  status: json['status'] as String?,
  stock: json['stock'] == null
      ? null
      : CylinderStock.fromJson(json['stock'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CylinderToJson(Cylinder instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'size': instance.size,
  'short_code': instance.shortCode,
  'color1': instance.color1,
  'color2': instance.color2,
  'reorder_level': instance.reorderLevel,
  'capacity': instance.capacity,
  'status': instance.status,
  'stock': instance.stock?.toJson(),
};

CylinderStock _$CylinderStockFromJson(Map<String, dynamic> json) =>
    CylinderStock(
      filledQty: _toInt(json['filled_qty']),
      emptyQty: _toInt(json['empty_qty']),
      capacity: _toIntNull(json['capacity']),
    );

Map<String, dynamic> _$CylinderStockToJson(CylinderStock instance) =>
    <String, dynamic>{
      'filled_qty': instance.filledQty,
      'empty_qty': instance.emptyQty,
      'capacity': instance.capacity,
    };
