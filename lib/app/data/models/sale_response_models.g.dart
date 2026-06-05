// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleDetailResponse _$SaleDetailResponseFromJson(Map<String, dynamic> json) =>
    SaleDetailResponse(
      sale: Sale.fromJson(json['sale'] as Map<String, dynamic>),
      paymentHistory: json['payment_history'] as List<dynamic>,
    );

Map<String, dynamic> _$SaleDetailResponseToJson(SaleDetailResponse instance) =>
    <String, dynamic>{
      'sale': instance.sale.toJson(),
      'payment_history': instance.paymentHistory,
    };

SaleCreateResponse _$SaleCreateResponseFromJson(Map<String, dynamic> json) =>
    SaleCreateResponse(
      sale: Sale.fromJson(json['sale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaleCreateResponseToJson(SaleCreateResponse instance) =>
    <String, dynamic>{
      'sale': instance.sale.toJson(),
    };
