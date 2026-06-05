import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'allocation_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final int id;
  @JsonKey(fromJson: _toString)
  final String name;
  @JsonKey(fromJson: _toString)
  final String email;
  @JsonKey(fromJson: _toStringNull)
  final String? phone;
  @JsonKey(fromJson: _toString)
  final String role;
  @JsonKey(name: 'avatar_initials', fromJson: _toStringNull)
  final String? avatarInitials;
  @JsonKey(name: 'is_active', fromJson: _toBoolNull)
  final bool? isActive;
  @JsonKey(name: 'unread_notifications', fromJson: _toIntNull)
  final int? unreadNotifications;
  final List<Allocation>? allocations;

  const User({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone,
    this.role = '',
    this.avatarInitials,
    this.isActive,
    this.unreadNotifications,
    this.allocations,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, name, email, phone, role, avatarInitials, isActive, unreadNotifications, allocations];
}

@JsonSerializable(explicitToJson: true)
class AuthResponse extends Equatable {
  final User user;
  @JsonKey(name: 'access_token', fromJson: _toString)
  final String accessToken;
  @JsonKey(name: 'refresh_token', fromJson: _toString)
  final String refreshToken;
  @JsonKey(name: 'token_type', fromJson: _toString)
  final String tokenType;
  @JsonKey(name: 'expires_in', fromJson: _toInt)
  final int expiresIn;

  const AuthResponse({
    required this.user,
    this.accessToken = '',
    this.refreshToken = '',
    this.tokenType = '',
    this.expiresIn = 0,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object?> get props => [user, accessToken, refreshToken, tokenType, expiresIn];
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
