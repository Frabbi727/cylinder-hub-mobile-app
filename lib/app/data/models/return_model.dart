import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cylinder_model.dart';
import 'customer_model.dart';
import 'user_model.dart';

part 'return_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CylinderReturn extends Equatable {
  final int id;
  @JsonKey(name: 'return_date')
  final String returnDate;
  final int qty;
  final String type;
  @JsonKey(name: 'is_extra')
  final bool isExtra;
  @JsonKey(name: 'extra_reason')
  final String? extraReason;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;
  final String? notes;
  final Cylinder? cylinder;
  final Customer? customer;
  final User? salesman;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const CylinderReturn({
    required this.id,
    required this.returnDate,
    required this.qty,
    required this.type,
    required this.isExtra,
    this.extraReason,
    this.isVerified,
    this.notes,
    this.cylinder,
    this.customer,
    this.salesman,
    this.createdAt,
  });

  factory CylinderReturn.fromJson(Map<String, dynamic> json) => _$CylinderReturnFromJson(json);
  Map<String, dynamic> toJson() => _$CylinderReturnToJson(this);

  @override
  List<Object?> get props => [
        id,
        returnDate,
        qty,
        type,
        isExtra,
        extraReason,
        isVerified,
        notes,
        cylinder,
        customer,
        salesman,
        createdAt,
      ];
}
