// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
      id: (json['id'] as num).toInt(),
      saleDate: _toString(json['sale_date']),
      totalAmount: _toDouble(json['total_amount']),
      paidAmount: _toDouble(json['paid_amount']),
      dueAmount: _toDouble(json['due_amount']),
      paymentType: _toString(json['payment_type']),
      notes: _toStringNull(json['notes']),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: _toStringNull(json['created_at']),
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
      qty: _toInt(json['qty']),
      unitPrice: _toDouble(json['unit_price']),
      unitCost: _toDoubleNull(json['unit_cost']),
      profit: _toDoubleNull(json['profit']),
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
      amount: _toDouble(json['amount']),
      collectionDate: _toString(json['collection_date']),
      collectedBy: _toStringNull(json['collected_by']),
      notes: _toStringNull(json['notes']),
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
