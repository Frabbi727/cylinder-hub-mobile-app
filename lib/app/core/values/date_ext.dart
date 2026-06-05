import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  /// Format: 5 June 2026
  String get toStandardDate => DateFormat('d MMMM y').format(this);

  /// Format: 2026-06-05
  String get toApiDate => DateFormat('yyyy-MM-dd').format(this);

  /// Format: 5 June
  String get toDayMonth => DateFormat('d MMMM').format(this);

  /// Format: 05/06
  String get toDayMonthSlash => DateFormat('dd/MM').format(this);
}

extension StringDateFormatter on String? {
  /// Parses string and formats to: 5 June 2026
  String get toStandardDate {
    if (this == null || this!.isEmpty) return '';
    final date = DateTime.tryParse(this!);
    return date?.toStandardDate ?? this!;
  }

  /// Parses string and formats to: 2026-06-05
  String get toApiDate {
    if (this == null || this!.isEmpty) return '';
    final date = DateTime.tryParse(this!);
    return date?.toApiDate ?? this!;
  }
}
