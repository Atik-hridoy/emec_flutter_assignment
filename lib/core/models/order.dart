import 'package:flutter/foundation.dart';

enum OrderStatus {
  assigned,
  pickedUp,
  enRoute,
  delivered,
  failed;

  String toJson() => name.replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      ).toUpperCase();

  static OrderStatus fromJson(String json) {
    return OrderStatus.values.firstWhere(
      (e) => e.toJson() == json,
      orElse: () => OrderStatus.assigned,
    );
  }

  String get displayName {
    return switch (this) {
      OrderStatus.assigned => 'Assigned',
      OrderStatus.pickedUp => 'Picked Up',
      OrderStatus.enRoute => 'En Route',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.failed => 'Failed',
    };
  }
}

@immutable
class Order {
  final String id;
  final int sequence;
  final OrderStatus status;
  final String customerName;
  final String address;
  final double lat;
  final double lng;
  final String timeWindowStart;
  final String timeWindowEnd;
  final List<String> items;
  final String deliveryInstructions;
  final int totalBdt;

  const Order({
    required this.id,
    required this.sequence,
    required this.status,
    required this.customerName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.timeWindowStart,
    required this.timeWindowEnd,
    required this.items,
    required this.deliveryInstructions,
    required this.totalBdt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      sequence: json['sequence'] as int,
      status: OrderStatus.fromJson(json['status'] as String),
      customerName: json['customer_name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timeWindowStart: json['time_window_start'] as String,
      timeWindowEnd: json['time_window_end'] as String,
      items: List<String>.from(json['items'] as List),
      deliveryInstructions: json['delivery_instructions'] as String,
      totalBdt: json['total_bdt'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequence': sequence,
        'status': status.toJson(),
        'customer_name': customerName,
        'address': address,
        'lat': lat,
        'lng': lng,
        'time_window_start': timeWindowStart,
        'time_window_end': timeWindowEnd,
        'items': items,
        'delivery_instructions': deliveryInstructions,
        'total_bdt': totalBdt,
      };

  Order copyWith({
    String? id,
    int? sequence,
    OrderStatus? status,
    String? customerName,
    String? address,
    double? lat,
    double? lng,
    String? timeWindowStart,
    String? timeWindowEnd,
    List<String>? items,
    String? deliveryInstructions,
    int? totalBdt,
  }) {
    return Order(
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      timeWindowStart: timeWindowStart ?? this.timeWindowStart,
      timeWindowEnd: timeWindowEnd ?? this.timeWindowEnd,
      items: items ?? this.items,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      totalBdt: totalBdt ?? this.totalBdt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ status.hashCode;
}
