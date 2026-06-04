import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? address;
  @JsonKey(name: 'total_due')
  final String? totalDue;
  @JsonKey(name: 'total_revenue')
  final double? totalRevenue;
  @JsonKey(name: 'total_paid')
  final double? totalPaid;
  @JsonKey(name: 'added_by')
  final int? addedBy;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const Customer({
    required this.id,
    required this.name,
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
  @JsonKey(name: 'customer_id')
  final int customerId;
  final String name;
  final String? phone;
  @JsonKey(name: 'total_due')
  final double totalDue;
  @JsonKey(name: 'oldest_due_date')
  final String oldestDueDate;
  @JsonKey(name: 'days_overdue')
  final int daysOverdue;
  @JsonKey(name: 'unpaid_sales_count')
  final int unpaidSalesCount;
  @JsonKey(name: 'salesman_name')
  final String? salesmanName;

  const OverdueCustomer({
    required this.customerId,
    required this.name,
    this.phone,
    required this.totalDue,
    required this.oldestDueDate,
    required this.daysOverdue,
    required this.unpaidSalesCount,
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
