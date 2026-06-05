import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Equatable {
  final int id;
  @JsonKey(fromJson: _toString)
  final String name;
  @JsonKey(fromJson: _toStringNull)
  final String? phone;
  @JsonKey(fromJson: _toStringNull)
  final String? address;
  @JsonKey(name: 'total_due', fromJson: _toDoubleNull)
  final double? totalDue;
  @JsonKey(name: 'total_revenue', fromJson: _toDoubleNull)
  final double? totalRevenue;
  @JsonKey(name: 'total_paid', fromJson: _toDoubleNull)
  final double? totalPaid;
  @JsonKey(name: 'added_by', fromJson: _toIntNull)
  final int? addedBy;
  @JsonKey(name: 'is_active', fromJson: _toBoolNull)
  final bool? isActive;
  @JsonKey(name: 'created_at', fromJson: _toStringNull)
  final String? createdAt;

  const Customer({
    required this.id,
    this.name = '',
    this.phone,
    this.address,
    this.totalDue,
    this.totalRevenue,
    this.totalPaid,
    this.addedBy,
    this.isActive,
    this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        address,
        totalDue,
        totalRevenue,
        totalPaid,
        addedBy,
        isActive,
        createdAt,
      ];
}

@JsonSerializable(explicitToJson: true)
class OverdueCustomer extends Equatable {
  @JsonKey(name: 'customer_id', fromJson: _toInt)
  final int customerId;
  @JsonKey(fromJson: _toString)
  final String name;
  @JsonKey(fromJson: _toStringNull)
  final String? phone;
  @JsonKey(name: 'total_due', fromJson: _toDouble)
  final double totalDue;
  @JsonKey(name: 'oldest_due_date', fromJson: _toString)
  final String oldestDueDate;
  @JsonKey(name: 'days_overdue', fromJson: _toInt)
  final int daysOverdue;
  @JsonKey(name: 'unpaid_sales_count', fromJson: _toInt)
  final int unpaidSalesCount;
  @JsonKey(name: 'salesman_name', fromJson: _toStringNull)
  final String? salesmanName;

  const OverdueCustomer({
    this.customerId = 0,
    this.name = '',
    this.phone,
    this.totalDue = 0.0,
    this.oldestDueDate = '',
    this.daysOverdue = 0,
    this.unpaidSalesCount = 0,
    this.salesmanName,
  });

  factory OverdueCustomer.fromJson(Map<String, dynamic> json) => _$OverdueCustomerFromJson(json);
  Map<String, dynamic> toJson() => _$OverdueCustomerToJson(this);

  @override
  List<Object?> get props => [
        customerId,
        name,
        phone,
        totalDue,
        oldestDueDate,
        daysOverdue,
        unpaidSalesCount,
        salesmanName,
      ];
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
bool? _toBoolNull(dynamic v) => v == null ? null : _toBool(v);
double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return (v as num).toDouble(); }
int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return (v as num).toInt(); }
double? _toDoubleNull(dynamic v) => v == null ? null : _toDouble(v);
int? _toIntNull(dynamic v) => v == null ? null : _toInt(v);
