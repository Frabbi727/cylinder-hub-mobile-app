// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cylinder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cylinder _$CylinderFromJson(Map<String, dynamic> json) => Cylinder(
      id: (json['id'] as num).toInt(),
      name: _toString(json['name']),
      size: _toString(json['size']),
      shortCode: _toStringNull(json['short_code']),
      color1: _toStringNull(json['color1']),
      color2: _toStringNull(json['color2']),
      reorderLevel: _toIntNull(json['reorder_level']),
      capacity: _toIntNull(json['capacity']),
      status: _toStringNull(json['status']),
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
