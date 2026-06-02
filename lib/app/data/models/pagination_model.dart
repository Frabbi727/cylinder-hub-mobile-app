class PaginationModel<T> {
  final List<T> items;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  PaginationModel({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PaginationModel(
      items: (json['items'] as List).map((i) => fromJsonT(i)).toList(),
      totalCount: json['total_count'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
    );
  }
}
