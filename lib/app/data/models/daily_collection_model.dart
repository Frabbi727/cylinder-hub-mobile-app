import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'sale_model.dart';
import 'customer_model.dart';

part 'daily_collection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyCollectionResponse extends Equatable {
  final List<DueCollection>? collections;
  @JsonKey(fromJson: _toDouble)
  final double? total;
  final String? date;

  const DailyCollectionResponse({
    this.collections,
    this.total,
    this.date,
  });

  factory DailyCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyCollectionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DailyCollectionResponseToJson(this);

  @override
  List<Object?> get props => [collections, total, date];
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
