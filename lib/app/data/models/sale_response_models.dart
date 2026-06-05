import 'package:json_annotation/json_annotation.dart';
import 'sale_model.dart';

part 'sale_response_models.g.dart';

@JsonSerializable()
class SaleDetailResponse {
  final Sale sale;
  @JsonKey(name: 'payment_history')
  final List<dynamic> paymentHistory;

  SaleDetailResponse({required this.sale, required this.paymentHistory});
  
  factory SaleDetailResponse.fromJson(Map<String, dynamic> json) => _$SaleDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SaleDetailResponseToJson(this);
}

@JsonSerializable()
class SaleCreateResponse {
  final Sale sale;
  
  SaleCreateResponse({required this.sale});
  
  factory SaleCreateResponse.fromJson(Map<String, dynamic> json) => _$SaleCreateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SaleCreateResponseToJson(this);
}
