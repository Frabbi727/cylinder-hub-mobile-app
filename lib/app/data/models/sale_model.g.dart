// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
  id: (json['id'] as num).toInt(),
  saleDate: json['sale_date'] as String,
  totalAmount: json['total_amount'] as String,
  paidAmount: json['paid_amount'] as String,
  dueAmount: (json['due_amount'] as num).toDouble(),
  paymentType: json['payment_type'] as String,
  notes: json['notes'] as String?,
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
  'id': instance.id,
  'sale_date': instance.saleDate,
  'total_amount': instance.totalAmount,
  'paid_amount': instance.paidAmount,
  'due_amount': instance.dueAmount,
  'payment_type': instance.paymentType,
  'notes': instance.notes,
  'customer': instance.customer?.toJson(),
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'created_at': instance.createdAt,
};

SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => SaleItem(
  id: (json['id'] as num).toInt(),
  cylinder: json['cylinder'] == null
      ? null
      : Cylinder.fromJson(json['cylinder'] as Map<String, dynamic>),
  qty: (json['qty'] as num).toInt(),
  unitPrice: (json['unit_price'] as num).toDouble(),
  unitCost: (json['unit_cost'] as num?)?.toDouble(),
  profit: (json['profit'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SaleItemToJson(SaleItem instance) => <String, dynamic>{
  'id': instance.id,
  'cylinder': instance.cylinder?.toJson(),
  'qty': instance.qty,
  'unit_price': instance.unitPrice,
  'unit_cost': instance.unitCost,
  'profit': instance.profit,
};

DueCollection _$DueCollectionFromJson(Map<String, dynamic> json) =>
    DueCollection(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      collectionDate: json['collection_date'] as String,
      collectedBy: json['collected_by'] as String?,
      notes: json['notes'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      sale: json['sale'] == null
          ? null
          : Sale.fromJson(json['sale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DueCollectionToJson(DueCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'collection_date': instance.collectionDate,
      'collected_by': instance.collectedBy,
      'notes': instance.notes,
      'customer': instance.customer?.toJson(),
      'sale': instance.sale?.toJson(),
    };
