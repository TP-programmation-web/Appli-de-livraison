class Delivery {
  String id;
  String orderNumber;
  String customerName;
  String address;
  String phone;
  int amount;
  String status;
  List<DeliveryItem> items;
  String distance;
  String priority;
  String estimatedTime;
  String? accessCode;

  Delivery({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.amount,
    required this.status,
    required this.items,
    required this.distance,
    required this.priority,
    required this.estimatedTime,
    this.accessCode,
  });
}

class DeliveryItem {
  final String name;
  final String category;
  final int quantity;

  DeliveryItem({
    required this.name,
    required this.category,
    required this.quantity,
  });
}