import 'package:flutter/material.dart';
import 'package:foodpanda_seller/models/order.dart';
import 'package:foodpanda_seller/orders/controllers/order_controller.dart';
import 'package:foodpanda_seller/orders/widgets/order_card.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderController orderController = OrderController();

  Future acceptOrder({required Order order}) async {
    await orderController.acceptOrder(order: order);
  }
  Future cancelOrder({required Order order}) async {
    await orderController.cancelOrder(order: order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff041C32),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff041C32),
        title: const Text(
          'الطلبات',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,

          ),
        ),
        centerTitle: true,
      ),
       body: StreamBuilder<List<Order>>(
    stream: orderController.fetchOrder(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
    return const Center(
    child: Text('No orders available'),
    );
    }

    return ListView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
    final order = snapshot.data![index];

    return OrderCard(

    order: order,
    acceptOrder: () => acceptOrder(
    order: order,
    ),
    );
    },
    );
    },
    ),

    );
  }
}
