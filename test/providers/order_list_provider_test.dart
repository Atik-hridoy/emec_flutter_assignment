import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:emec_flutter_assignment/core/models/driver.dart';
import 'package:emec_flutter_assignment/core/models/order.dart';
import 'package:emec_flutter_assignment/core/models/shift.dart';
import 'package:emec_flutter_assignment/core/providers/api_provider.dart';
import 'package:emec_flutter_assignment/core/repositories/shift_repository.dart';
import 'package:emec_flutter_assignment/features/order_list/order_list_provider.dart';

class MockShiftRepository extends Mock implements ShiftRepository {}

void main() {
  group('OrderListProvider', () {
    late MockShiftRepository mockRepository;

    setUp(() {
      mockRepository = MockShiftRepository();
    });

    test('loads shift data successfully', () async {
      // Arrange
      final mockDriver = const Driver(
        id: 'd1',
        name: 'Test Driver',
        vehicle: 'Bike',
      );

      final mockOrders = [
        const Order(
          id: 'order-001',
          sequence: 1,
          status: OrderStatus.assigned,
          customerName: 'Customer 1',
          address: 'Address 1',
          lat: 23.7946,
          lng: 90.4050,
          timeWindowStart: '13:00',
          timeWindowEnd: '15:00',
          items: ['Item 1'],
          deliveryInstructions: 'Instructions',
          totalBdt: 1000,
        ),
        const Order(
          id: 'order-002',
          sequence: 2,
          status: OrderStatus.assigned,
          customerName: 'Customer 2',
          address: 'Address 2',
          lat: 23.7808,
          lng: 90.4147,
          timeWindowStart: '14:00',
          timeWindowEnd: '16:00',
          items: ['Item 2'],
          deliveryInstructions: 'Instructions',
          totalBdt: 2000,
        ),
      ];

      final mockShift = Shift(
        driver: mockDriver,
        shiftDate: '2025-05-01',
        routeGeometry: RouteGeometry(
          type: 'LineString',
          coordinates: [
            [90.4050, 23.7946],
            [90.4147, 23.7808],
          ],
        ),
        orders: mockOrders,
      );

      when(mockRepository.getShift()).thenAnswer((_) async => mockShift);

      // Act
      final container = ProviderContainer(
        overrides: [
          shiftRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = await container.read(shiftProvider.future);

      // Assert
      expect(result, mockShift);
      expect(result.orders.length, 2);
      expect(result.orders.first.customerName, 'Customer 1');
      expect(result.orders.first.status, OrderStatus.assigned);
    });

    test('handles order status transition', () async {
      // Arrange
      final initialOrder = const Order(
        id: 'order-001',
        sequence: 1,
        status: OrderStatus.assigned,
        customerName: 'Customer 1',
        address: 'Address 1',
        lat: 23.7946,
        lng: 90.4050,
        timeWindowStart: '13:00',
        timeWindowEnd: '15:00',
        items: ['Item 1'],
        deliveryInstructions: 'Instructions',
        totalBdt: 1000,
      );

      // Act
      final updatedOrder = initialOrder.copyWith(status: OrderStatus.pickedUp);

      // Assert
      expect(initialOrder.status, OrderStatus.assigned);
      expect(updatedOrder.status, OrderStatus.pickedUp);
      expect(updatedOrder.id, initialOrder.id);
      expect(updatedOrder.customerName, initialOrder.customerName);
    });

    test('shift contains correct route geometry', () async {
      // Arrange
      final mockDriver = const Driver(
        id: 'd1',
        name: 'Test Driver',
        vehicle: 'Bike',
      );

      final mockShift = Shift(
        driver: mockDriver,
        shiftDate: '2025-05-01',
        routeGeometry: RouteGeometry(
          type: 'LineString',
          coordinates: [
            [90.4125, 23.8103],
            [90.3795, 23.8759],
            [90.4050, 23.7946],
          ],
        ),
        orders: [],
      );

      // Act & Assert
      expect(mockShift.routeGeometry.type, 'LineString');
      expect(mockShift.routeGeometry.coordinates.length, 3);
      expect(mockShift.routeGeometry.coordinates.first, [90.4125, 23.8103]);
    });
  });
}
