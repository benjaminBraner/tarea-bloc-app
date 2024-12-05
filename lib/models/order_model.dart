// lib/models/order_model.dart
class Order {
  final String? id;
  final String name;
  final String avatar;
  final String email;
  final double totalAmount;
  final bool status;
  final int date;

  Order({
    this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.totalAmount,
    required this.status,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      email: json['email'],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? false,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'total_amount': totalAmount,
      'status': status,
      'date': date,
    };
  }

  Order copyWith({
    String? id,
    String? name,
    String? avatar,
    String? email,
    double? totalAmount,
    bool? status,
    int? date,
  }) {
    return Order(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}