enum OrderCompletionStatus {
  completed,
  notCompleted,
  pending,
}

class OrderCompletion {
  final OrderCompletionStatus status;
  final String checkoutId;
  final String? orderId;

  const OrderCompletion({
    required this.status,
    required this.checkoutId,
    required this.orderId,
  });
}
