import 'package:flutter/foundation.dart';
import 'driver.dart';
import 'order.dart';

@immutable
class RouteGeometry {
  final String type;
  final List<List<double>> coordinates;

  const RouteGeometry({
    required this.type,
    required this.coordinates,
  });

  factory RouteGeometry.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    return RouteGeometry(
      type: json['type'] as String,
      coordinates: coords
          .map((coord) => List<double>.from(
              (coord as List).map((e) => (e as num).toDouble())))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

@immutable
class Shift {
  final Driver driver;
  final String shiftDate;
  final RouteGeometry routeGeometry;
  final List<Order> orders;

  const Shift({
    required this.driver,
    required this.shiftDate,
    required this.routeGeometry,
    required this.orders,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      shiftDate: json['shift_date'] as String,
      routeGeometry: RouteGeometry.fromJson(
          json['route_geometry'] as Map<String, dynamic>),
      orders: (json['orders'] as List)
          .map((o) => Order.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'driver': driver.toJson(),
        'shift_date': shiftDate,
        'route_geometry': routeGeometry.toJson(),
        'orders': orders.map((o) => o.toJson()).toList(),
      };

  Shift copyWith({
    Driver? driver,
    String? shiftDate,
    RouteGeometry? routeGeometry,
    List<Order>? orders,
  }) {
    return Shift(
      driver: driver ?? this.driver,
      shiftDate: shiftDate ?? this.shiftDate,
      routeGeometry: routeGeometry ?? this.routeGeometry,
      orders: orders ?? this.orders,
    );
  }

  /// Update a single order in the shift
  Shift updateOrder(Order updatedOrder) {
    final updatedOrders = orders.map((o) => o.id == updatedOrder.id ? updatedOrder : o).toList();
    return copyWith(orders: updatedOrders);
  }
}
