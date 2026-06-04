// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Allocation _$AllocationFromJson(Map<String, dynamic> json) => Allocation(
  id: (json['id'] as num).toInt(),
  cylinderId: (json['cylinder_id'] as num).toInt(),
  allocationDate: json['allocation_date'] as String,
  qty: (json['qty'] as num).toInt(),
  salePrice: json['sale_price'] as String,
  soldQty: (json['sold_qty'] as num).toInt(),
  returnedQty: (json['returned_qty'] as num).toInt(),
  collectedAmount: json['collected_amount'] as String,
  isReconciled: json['is_reconciled'] as bool,
  withSalesman: (json['with_salesman'] as num).toInt(),
  soldPct: (json['sold_pct'] as num).toInt(),
  cashCollectedActual: (json['cash_collected_actual'] as num?)?.toDouble(),
  dueFromSales: (json['due_from_sales'] as num?)?.toDouble(),
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
  customer: json['customer'] as String,
  dueAmount: (json['due_amount'] as num).toDouble(),
);

Map<String, dynamic> _$CustomerDueToJson(CustomerDue instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'due_amount': instance.dueAmount,
    };
