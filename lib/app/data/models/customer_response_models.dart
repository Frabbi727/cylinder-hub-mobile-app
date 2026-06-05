 import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'customer_model.dart';

part 'customer_response_models.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerEmptyResponse extends Equatable {
  final Customer? customer;
  final List<CustomerEmptyBalance> balances;
  @JsonKey(name: 'total_pending', fromJson: _toInt)
  final int totalPending;

  const CustomerEmptyResponse({
    this.customer,
    required this.balances,
    required this.totalPending,
  });

  factory CustomerEmptyResponse.fromJson(Map<String, dynamic> json) => _$CustomerEmptyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerEmptyResponseToJson(this);

  @override
  List<Object?> get props => [customer, balances, totalPending];
}

@JsonSerializable(explicitToJson: true)
class CustomerEmptyBalance extends Equatable {
  @JsonKey(name: 'cylinder_id', fromJson: _toInt)
  final int cylinderId;
  @JsonKey(name: 'cylinder_name')
  final String cylinderName;
  @JsonKey(name: 'cylinder_size')
  final String cylinderSize;
  final String? color1;
  final String? color2;
  @JsonKey(name: 'sold_qty', fromJson: _toInt)
  final int soldQty;
  @JsonKey(name: 'returned_qty', fromJson: _toInt)
  final int returnedQty;
  @JsonKey(name: 'pending_qty', fromJson: _toInt)
  final int pendingQty;

  const CustomerEmptyBalance({
    required this.cylinderId,
    required this.cylinderName,
    required this.cylinderSize,
    this.color1,
    this.color2,
    required this.soldQty,
    required this.returnedQty,
    required this.pendingQty,
  });

  factory CustomerEmptyBalance.fromJson(Map<String, dynamic> json) => _$CustomerEmptyBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerEmptyBalanceToJson(this);

  @override
  List<Object?> get props => [
        cylinderId,
        cylinderName,
        cylinderSize,
        color1,
        color2,
        soldQty,
        returnedQty,
        pendingQty,
      ];
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return (v as num).toInt();
}
