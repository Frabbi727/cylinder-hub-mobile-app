// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerEmptyResponse _$CustomerEmptyResponseFromJson(
  Map<String, dynamic> json,
) => CustomerEmptyResponse(
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  balances: (json['balances'] as List<dynamic>)
      .map((e) => CustomerEmptyBalance.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPending: _toInt(json['total_pending']),
);

Map<String, dynamic> _$CustomerEmptyResponseToJson(
  CustomerEmptyResponse instance,
) => <String, dynamic>{
  'customer': instance.customer?.toJson(),
  'balances': instance.balances.map((e) => e.toJson()).toList(),
  'total_pending': instance.totalPending,
};

CustomerEmptyBalance _$CustomerEmptyBalanceFromJson(
  Map<String, dynamic> json,
) => CustomerEmptyBalance(
  cylinderId: _toInt(json['cylinder_id']),
  cylinderName: json['cylinder_name'] as String,
  cylinderSize: json['cylinder_size'] as String,
  color1: json['color1'] as String?,
  color2: json['color2'] as String?,
  soldQty: _toInt(json['sold_qty']),
  returnedQty: _toInt(json['returned_qty']),
  pendingQty: _toInt(json['pending_qty']),
);

Map<String, dynamic> _$CustomerEmptyBalanceToJson(
  CustomerEmptyBalance instance,
) => <String, dynamic>{
  'cylinder_id': instance.cylinderId,
  'cylinder_name': instance.cylinderName,
  'cylinder_size': instance.cylinderSize,
  'color1': instance.color1,
  'color2': instance.color2,
  'sold_qty': instance.soldQty,
  'returned_qty': instance.returnedQty,
  'pending_qty': instance.pendingQty,
};
