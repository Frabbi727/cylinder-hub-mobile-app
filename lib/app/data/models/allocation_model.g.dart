// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Allocation _$AllocationFromJson(Map<String, dynamic> json) => Allocation(
  id: (json['id'] as num).toInt(),
  cylinderId: json['cylinder_id'] == null ? 0 : _toInt(json['cylinder_id']),
  allocationDate: json['allocation_date'] == null
      ? ''
      : _toString(json['allocation_date']),
  qty: json['qty'] == null ? 0 : _toInt(json['qty']),
  salePrice: json['sale_price'] == null ? 0.0 : _toDouble(json['sale_price']),
  soldQty: json['sold_qty'] == null ? 0 : _toInt(json['sold_qty']),
  returnedQty: json['returned_qty'] == null ? 0 : _toInt(json['returned_qty']),
  collectedAmount: json['collected_amount'] == null
      ? 0.0
      : _toDouble(json['collected_amount']),
  isReconciled: json['is_reconciled'] == null
      ? false
      : _toBool(json['is_reconciled']),
  withSalesman: json['with_salesman'] == null
      ? 0
      : _toInt(json['with_salesman']),
  soldPct: json['sold_pct'] == null ? 0 : _toInt(json['sold_pct']),
  cashCollectedActual: _toDoubleNull(json['cash_collected_actual']),
  dueFromSales: _toDoubleNull(json['due_from_sales']),
  customerDues: (json['customer_dues'] as List<dynamic>?)
      ?.map((e) => CustomerDue.fromJson(e as Map<String, dynamic>))
      .toList(),
  cylinder: json['cylinder'] == null
      ? null
      : Cylinder.fromJson(json['cylinder'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AllocationToJson(Allocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cylinder_id': instance.cylinderId,
      'allocation_date': instance.allocationDate,
      'qty': instance.qty,
      'sale_price': instance.salePrice,
      'sold_qty': instance.soldQty,
      'returned_qty': instance.returnedQty,
      'collected_amount': instance.collectedAmount,
      'is_reconciled': instance.isReconciled,
      'with_salesman': instance.withSalesman,
      'sold_pct': instance.soldPct,
      'cash_collected_actual': instance.cashCollectedActual,
      'due_from_sales': instance.dueFromSales,
      'customer_dues': instance.customerDues?.map((e) => e.toJson()).toList(),
      'cylinder': instance.cylinder?.toJson(),
    };

CustomerDue _$CustomerDueFromJson(Map<String, dynamic> json) => CustomerDue(
  customer: json['customer'] == null ? '' : _toString(json['customer']),
  dueAmount: json['due_amount'] == null ? 0.0 : _toDouble(json['due_amount']),
);

Map<String, dynamic> _$CustomerDueToJson(CustomerDue instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'due_amount': instance.dueAmount,
    };
