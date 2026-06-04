import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'sale_model.dart';
import 'allocation_model.dart';

part 'report_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesmanReport extends Equatable {
  final User? salesman;
  final ReportPeriod? period;
  @JsonKey(name: 'total_allocated')
  final int totalAllocated;
  @JsonKey(name: 'total_sold')
  final int totalSold;
  @JsonKey(name: 'total_returned')
  final int totalReturned;
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @JsonKey(name: 'total_cash_collected')
  final double totalCashCollected;
  @JsonKey(name: 'total_dues_created')
  final double totalDuesCreated;
  @JsonKey(name: 'total_dues_collected')
  final double totalDuesCollected;
  @JsonKey(name: 'still_outstanding')
  final double stillOutstanding;
  @JsonKey(name: 'collection_rate_pct')
  final double collectionRatePct;
  @JsonKey(name: 'customers_reached')
  final int customersReached;
  @JsonKey(name: 'sell_through_rate')
  final double sellThroughRate;
  @JsonKey(name: 'pay_breakdown')
  final Map<String, int>? payBreakdown;
  @JsonKey(name: 'daily_revenue')
  final Map<String, double>? dailyRevenue;
  final List<Sale>? sales;
  final List<Allocation>? allocations;

  const SalesmanReport({
    this.salesman,
    this.period,
    required this.totalAllocated,
    required this.totalSold,
    required this.totalReturned,
    required this.totalRevenue,
    required this.totalCashCollected,
    required this.totalDuesCreated,
    required this.totalDuesCollected,
    required this.stillOutstanding,
    required this.collectionRatePct,
    required this.customersReached,
    required this.sellThroughRate,
    this.payBreakdown,
    this.dailyRevenue,
    this.sales,
    this.allocations,
  });

  factory SalesmanReport.fromJson(Map<String, dynamic> json) => _$SalesmanReportFromJson(json);
  Map<String, dynamic> toJson() => _$SalesmanReportToJson(this);

  @override
  List<Object?> get props => [
        salesman,
        period,
        totalAllocated,
        totalSold,
        totalReturned,
        totalRevenue,
        totalCashCollected,
        totalDuesCreated,
        totalDuesCollected,
        stillOutstanding,
        collectionRatePct,
        customersReached,
        sellThroughRate,
        payBreakdown,
        dailyRevenue,
        sales,
        allocations,
      ];
}

@JsonSerializable(explicitToJson: true)
class ReportPeriod extends Equatable {
  final String from;
  final String to;

  const ReportPeriod({required this.from, required this.to});

  factory ReportPeriod.fromJson(Map<String, dynamic> json) => _$ReportPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$ReportPeriodToJson(this);

  @override
  List<Object?> get props => [from, to];
}
