// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: _toInt(json['id']),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  totalDue: json['total_due'] as String?,
  totalRevenue: _toDoubleNull(json['total_revenue']),
  totalPaid: _toDoubleNull(json['total_paid']),
  addedBy: _toIntNull(json['added_by']),
  isActive: json['is_active'] as bool?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'address': instance.address,
  'total_due': instance.totalDue,
  'total_revenue': instance.totalRevenue,
  'total_paid': instance.totalPaid,
  'added_by': instance.addedBy,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
};

OverdueCustomer _$OverdueCustomerFromJson(Map<String, dynamic> json) =>
    OverdueCustomer(
      customerId: _toInt(json['customer_id']),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      totalDue: _toDouble(json['total_due']),
      oldestDueDate: json['oldest_due_date'] as String,
      daysOverdue: _toInt(json['days_overdue']),
      unpaidSalesCount: _toInt(json['unpaid_sales_count']),
      salesmanName: json['salesman_name'] as String?,
    );

Map<String, dynamic> _$OverdueCustomerToJson(OverdueCustomer instance) =>
    <String, dynamic>{
      'customer_id': instance.customerId,
      'name': instance.name,
      'phone': instance.phone,
      'total_due': instance.totalDue,
      'oldest_due_date': instance.oldestDueDate,
      'days_overdue': instance.daysOverdue,
      'unpaid_sales_count': instance.unpaidSalesCount,
      'salesman_name': instance.salesmanName,
    };
