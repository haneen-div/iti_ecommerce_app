class OrderModel {
  final String id;
  final List<Map<String, dynamic>> items;
  final double total;
  final DateTime date;
  final String status;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      total: (map['total'] ?? 0).toDouble(),
      date: (map['date'] as dynamic).toDate(),
      status: map['status'] ?? 'Confirmed',
    );
  }

  Map<String, dynamic> toMap() => {
    'items': items,
    'total': total,
    'date': date,
    'status': status,
  };
}