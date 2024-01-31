import 'package:flutter/material.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/models/order.dart';

class ViewDetail extends StatefulWidget {
  final Order order;
  const ViewDetail({super.key, required this.order});

  @override
  State<ViewDetail> createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
  bool isViewDetail = false;
  double totalFoodAndVAT = 0.0;

  
  @override
  Widget build(BuildContext context) {
    int quantity = calculateTotalQuantity();
    double totalWithoutDelivery = calculateTotalWithoutDelivery();

    return Column(
      children: [
        isViewDetail
            ? Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.order.foodOrders.length,
                      itemBuilder: (context, index) {
                        final food = widget.order.foodOrders[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${food.quantity}x',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.foodName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '\$ ${food.foodPrice * food.quantity}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  double calculateTotalWithoutDelivery() {
    return widget.order.foodOrders.fold<double>(
      0.0,
      (previousValue, foodOrder) =>
          previousValue + (foodOrder.foodPrice * foodOrder.quantity),
    );
  }
   int calculateTotalQuantity() {
    return widget.order.foodOrders.fold<int>(
      0,
      (previousValue, foodOrder) => previousValue + foodOrder.quantity,
    );
  }
}

