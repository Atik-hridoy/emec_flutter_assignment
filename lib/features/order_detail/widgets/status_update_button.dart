import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order.dart';
import '../order_detail_provider.dart';

class StatusUpdateButton extends ConsumerWidget {
  final String orderId;
  final Order order;

  const StatusUpdateButton({
    super.key,
    required this.orderId,
    required this.order,
  });

  OrderStatus? _getNextStatus(OrderStatus current) {
    return switch (current) {
      OrderStatus.assigned => OrderStatus.pickedUp,
      OrderStatus.pickedUp => OrderStatus.enRoute,
      OrderStatus.enRoute => null, // Can go to DELIVERED or FAILED
      OrderStatus.delivered => null,
      OrderStatus.failed => null,
    };
  }

  Color _getStatusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.assigned => Colors.blue,
      OrderStatus.pickedUp => Colors.blue,
      OrderStatus.enRoute => Colors.amber,
      OrderStatus.delivered => Colors.green,
      OrderStatus.failed => Colors.red,
    };
  }

  String _getButtonLabel(OrderStatus status) {
    return switch (status) {
      OrderStatus.assigned => 'Mark as Picked Up',
      OrderStatus.pickedUp => 'Start Delivery',
      OrderStatus.enRoute => 'Mark as Delivered',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.failed => 'Failed',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateNotifier = ref.watch(orderStatusUpdateProvider(orderId));

    return updateNotifier.when(
      data: (currentOrder) {
        final isCompleted =
            currentOrder.status == OrderStatus.delivered ||
            currentOrder.status == OrderStatus.failed;

        if (isCompleted) {
          return _buildDisabledButton(currentOrder.status);
        }

        if (currentOrder.status == OrderStatus.enRoute) {
          return Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  ref,
                  orderId,
                  OrderStatus.delivered,
                  'Mark as Delivered',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  ref,
                  orderId,
                  OrderStatus.failed,
                  'Report Failure',
                  Colors.red,
                ),
              ),
            ],
          );
        }

        final nextStatus = _getNextStatus(currentOrder.status);
        if (nextStatus == null) {
          return _buildDisabledButton(currentOrder.status);
        }

        return _buildActionButton(
          context,
          ref,
          orderId,
          nextStatus,
          _getButtonLabel(currentOrder.status),
          _getStatusColor(nextStatus),
        );
      },
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Error: ${error.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDisabledButton(OrderStatus status) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          _getButtonLabel(status),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    String orderId,
    OrderStatus nextStatus,
    String label,
    Color color,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        final isLoading = ref.watch(orderStatusUpdateProvider(orderId)).isLoading;

        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  try {
                    await ref
                        .read(orderStatusUpdateProvider(orderId).notifier)
                        .updateStatus(nextStatus);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order updated to ${nextStatus.displayName}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      },
    );
  }
}
