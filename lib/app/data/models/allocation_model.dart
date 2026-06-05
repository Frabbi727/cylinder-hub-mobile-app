import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cylinder_model.dart';

part 'allocation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Allocation extends Equatable {
  final int id;
  @JsonKey(name: 'cylinder_id', fromJson: _toInt)
  final int cylinderId;
  @JsonKey(name: 'allocation_date', fromJson: _toString)
  final String allocationDate;
  @JsonKey(fromJson: _toInt)
  final int qty;
  @JsonKey(name: 'sale_price', fromJson: _toDouble)
  final double salePrice;
  @JsonKey(name: 'sold_qty', fromJson: _toInt)
  final int soldQty;
  @JsonKey(name: 'returned_qty', fromJson: _toInt)
  final int returnedQty;
  @JsonKey(name: 'collected_amount', fromJson: _toDouble)
  final double collectedAmount;
  @JsonKey(name: 'is_reconciled', fromJson: _toBool)
  final bool isReconciled;
  @JsonKey(name: 'with_salesman', fromJson: _toInt)
  final int withSalesman;
  @JsonKey(name: 'sold_pct', fromJson: _toInt)
  final int soldPct;
  @JsonKey(name: 'cash_collected_actual', fromJson: _toDoubleNull)
  final double? cashCollectedActual;
  @JsonKey(name: 'due_from_sales', fromJson: _toDoubleNull)
  final double? dueFromSales;
  @JsonKey(name: 'customer_dues')
  final List<CustomerDue>? customerDues;
  final Cylinder? cylinder;

  const Allocation({
    required this.id,
    this.cylinderId = 0,
    this.allocationDate = '',
    this.qty = 0,
    this.salePrice = 0.0,
    this.soldQty = 0,
    this.returnedQty = 0,
    this.collectedAmount = 0.0,
    this.isReconciled = false,
    this.withSalesman = 0,
    this.soldPct = 0,
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
  @JsonKey(fromJson: _toString)
  final String customer;
  @JsonKey(name: 'due_amount', fromJson: _toDouble)
  final double dueAmount;

  const CustomerDue({
    this.customer = '',
    this.dueAmount = 0.0,
  });

  factory CustomerDue.fromJson(Map<String, dynamic> json) => _$CustomerDueFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerDueToJson(this);

  @override
  List<Object?> get props => [customer, dueAmount];
}

String _toString(dynamic v) => v?.toString() ?? '';
String? _toStringNull(dynamic v) => v?.toString();
bool _toBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == 'true' || s == '1' || s == 'yes' || s == 'active';
  }
  return false;
}
double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
