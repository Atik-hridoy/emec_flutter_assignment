import 'package:flutter/foundation.dart';

@immutable
class Driver {
  final String id;
  final String name;
  final String vehicle;

  const Driver({
    required this.id,
    required this.name,
    required this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      vehicle: json['vehicle'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'vehicle': vehicle,
      };

  Driver copyWith({
    String? id,
    String? name,
    String? vehicle,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
