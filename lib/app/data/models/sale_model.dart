import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'customer_model.dart';
import 'cylinder_model.dart';

part 'sale_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Sale extends Equatable {
  final int id;
  @JsonKey(name: 'sale_date', fromJson: _toString)
  final String saleDate;
  @JsonKey(name: 'total_amount', fromJson: _toDouble)
  final double totalAmount;
  @JsonKey(name: 'paid_amount', fromJson: _toDouble)
  final double paidAmount;
  @JsonKey(name: 'due_amount', fromJson: _toDouble)
  final double dueAmount;
  @JsonKey(name: 'payment_type', fromJson: _toString)
  final String paymentType;
  @JsonKey(fromJson: _toStringNull)
  final String? notes;
  final Customer? customer;
  final List<SaleItem>? items;
  @JsonKey(name: 'created_at', fromJson: _toStringNull)
  final String? createdAt;

  const Sale({
    required this.id,
    this.saleDate = '',
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.paymentType = '',
    this.notes,
    this.customer,
    this.items,
    this.createdAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
  Map<String, dynamic> toJson() => _$SaleToJson(this);

  @override
  List<Object?> get props => [
        id,
        saleDate,
        totalAmount,
        paidAmount,
        dueAmount,
        paymentType,
        notes,
        customer,
        items,
        createdAt,
      ];
}

@JsonSerializable(explicitToJson: true)
class SaleItem extends Equatable {
  final int id;
  final Cylinder? cylinder;
  @JsonKey(fromJson: _toInt)
  final int qty;
  @JsonKey(name: 'unit_price', fromJson: _toDouble)
  final double unitPrice;
  @JsonKey(name: 'unit_cost', fromJson: _toDoubleNull)
  final double? unitCost;
  @JsonKey(fromJson: _toDoubleNull)
  final double? profit;

  const SaleItem({
    required this.id,
    this.cylinder,
    this.qty = 0,
    this.unitPrice = 0.0,
    this.unitCost,
    this.profit,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaleItemToJson(this);

  @override
  List<Object?> get props => [id, cylinder, qty, unitPrice, unitCost, profit];
}

@JsonSerializable(explicitToJson: true)
class DueCollection extends Equatable {
  final int id;
  @JsonKey(fromJson: _toDouble)
  final double amount;
  @JsonKey(name: 'collection_date', fromJson: _toString)
  final String collectionDate;
  @JsonKey(name: 'collected_by', fromJson: _toStringNull)
  final String? collectedBy;
  @JsonKey(fromJson: _toStringNull)
  final String? notes;
  final Customer? customer;
  final Sale? sale;

  const DueCollection({
    required this.id,
    this.amount = 0.0,
    this.collectionDate = '',
    this.collectedBy,
    this.notes,
    this.customer,
    this.sale,
  });

  factory DueCollection.fromJson(Map<String, dynamic> json) => _$DueCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$DueCollectionToJson(this);

  @override
  List<Object?> get props => [id, amount, collectionDate, collectedBy, notes, customer, sale];
}

String _toString(dynamic v) => v?.toString() ?? '';
String? _toStringNull(dynamic v) => v?.toString();
double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
