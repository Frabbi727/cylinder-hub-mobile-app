// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: _toInt(json['id']),
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  role: json['role'] as String,
  avatarInitials: json['avatar_initials'] as String?,
  isActive: json['is_active'] as bool?,
  unreadNotifications: _toIntNull(json['unread_notifications']),
  allocations: (json['allocations'] as List<dynamic>?)
      ?.map((e) => Allocation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'avatar_initials': instance.avatarInitials,
  'is_active': instance.isActive,
  'unread_notifications': instance.unreadNotifications,
  'allocations': instance.allocations?.map((e) => e.toJson()).toList(),
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  tokenType: json['token_type'] as String,
  expiresIn: _toInt(json['expires_in']),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
