// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CylinderReturn _$CylinderReturnFromJson(Map<String, dynamic> json) =>
    CylinderReturn(
      id: _toInt(json['id']),
      returnDate: json['return_date'] as String,
      qty: _toInt(json['qty']),
      type: json['type'] as String,
      isExtra: json['is_extra'] as bool,
      extraReason: json['extra_reason'] as String?,
      isVerified: json['is_verified'] as bool?,
      notes: json['notes'] as String?,
      cylinder: json['cylinder'] == null
          ? null
          : Cylinder.fromJson(json['cylinder'] as Map<String, dynamic>),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      salesman: json['salesman'] == null
          ? null
          : User.fromJson(json['salesman'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$CylinderReturnToJson(CylinderReturn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'return_date': instance.returnDate,
      'qty': instance.qty,
      'type': instance.type,
      'is_extra': instance.isExtra,
      'extra_reason': instance.extraReason,
      'is_verified': instance.isVerified,
      'notes': instance.notes,
      'cylinder': instance.cylinder?.toJson(),
      'customer': instance.customer?.toJson(),
      'salesman': instance.salesman?.toJson(),
      'created_at': instance.createdAt,
    };
