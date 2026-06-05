// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] == null ? '' : _toString(json['name']),
      email: json['email'] == null ? '' : _toString(json['email']),
      phone: _toStringNull(json['phone']),
      role: json['role'] == null ? '' : _toString(json['role']),
      avatarInitials: _toStringNull(json['avatar_initials']),
      isActive: _toBoolNull(json['is_active']),
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
      accessToken: json['access_token'] == null ? '' : _toString(json['access_token']),
      refreshToken: json['refresh_token'] == null ? '' : _toString(json['refresh_token']),
      tokenType: json['token_type'] == null ? '' : _toString(json['token_type']),
      expiresIn: json['expires_in'] == null ? 0 : _toInt(json['expires_in']),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
