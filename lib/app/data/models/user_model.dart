import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'allocation_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  @JsonKey(name: 'avatar_initials')
  final String? avatarInitials;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'unread_notifications')
  final int? unreadNotifications;
  final List<Allocation>? allocations;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
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
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object?> get props => [user, accessToken, refreshToken, tokenType, expiresIn];
}
