// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyCollectionResponse _$DailyCollectionResponseFromJson(
        Map<String, dynamic> json) =>
    DailyCollectionResponse(
      collections: (json['collections'] as List<dynamic>?)
          ?.map((e) => DueCollection.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: _toDouble(json['total']),
      date: json['date'] as String?,
    );

Map<String, dynamic> _$DailyCollectionResponseToJson(
        DailyCollectionResponse instance) =>
    <String, dynamic>{
      'collections': instance.collections?.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'date': instance.date,
    };
