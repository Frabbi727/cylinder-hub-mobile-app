import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cylinder_model.dart';

part 'allocation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Allocation extends Equatable {
  final int id;
  @JsonKey(name: 'cylinder_id')
  final int cylinderId;
  @JsonKey(name: 'allocation_date')
  final String allocationDate;
  final int qty;
  @JsonKey(name: 'sale_price')
  final String salePrice;
  @JsonKey(name: 'sold_qty')
  final int soldQty;
  @JsonKey(name: 'returned_qty')
  final int returnedQty;
  @JsonKey(name: 'collected_amount')
  final String collectedAmount;
  @JsonKey(name: 'is_reconciled')
  final bool isReconciled;
  @JsonKey(name: 'with_salesman')
  final int withSalesman;
  @JsonKey(name: 'sold_pct')
  final int soldPct;
  @JsonKey(name: 'cash_collected_actual')
  final double? cashCollectedActual;
  @JsonKey(name: 'due_from_sales')
  final double? dueFromSales;
  @JsonKey(name: 'customer_dues')
  final List<CustomerDue>? customerDues;
  final Cylinder? cylinder;

  const Allocation({
    required this.id,
    required this.cylinderId,
    required this.allocationDate,
    required this.qty,
    required this.salePrice,
    required this.soldQty,
    required this.returnedQty,
    required this.collectedAmount,
    required this.isReconciled,
    required this.withSalesman,
    required this.soldPct,
    this.cashCollectedActual,
    this.dueFromSales,
    this.customerDues,
    this.cylinder,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) => _$AllocationFromJson(json);
  Map<String, dynamic> toJson() => _$AllocationToJson(this);

  @override
  List<Object?> get props => [
        id,
        cylinderId,
        allocationDate,
        qty,
        salePrice,
        soldQty,
        returnedQty,
        collectedAmount,
        isReconciled,
        withSalesman,
        soldPct,
        cashCollectedActual,
        dueFromSales,
        customerDues,
        cylinder,
      ];
}

@JsonSerializable(explicitToJson: true)
class CustomerDue extends Equatable {
  final String customer;
  @JsonKey(name: 'due_amount')
  final double dueAmount;

  const CustomerDue({
    required this.customer,
    required this.dueAmount,
  });

  factory CustomerDue.fromJson(Map<String, dynamic> json) => _$CustomerDueFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerDueToJson(this);

  @override
  List<Object?> get props => [customer, dueAmount];
}

double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
