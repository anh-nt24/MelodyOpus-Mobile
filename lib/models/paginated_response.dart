class PaginatedResponse<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int pageSize;
  final int pageNumber;

  PaginatedResponse({required this.content, required this.totalPages, required this.totalElements, required this.pageSize, required this.pageNumber});

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PaginatedResponse(
      content: (json['content'] as List).map((item) => fromJson(item)).toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      pageSize: json['size'],
      pageNumber: json['pageable']['pageNumber'],
    );
  }
}