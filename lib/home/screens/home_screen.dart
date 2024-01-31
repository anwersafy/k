import 'package:flutter/material.dart';
import 'package:foodpanda_seller/banner/screens/banner_screen.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/screens/menu_screen.dart';
import 'package:foodpanda_seller/home/screens/qr.dart';
import 'package:foodpanda_seller/home/widgets/my_drawer.dart';
import 'package:foodpanda_seller/models/order.dart';
import 'package:foodpanda_seller/orders/controllers/order_controller.dart';
import 'package:foodpanda_seller/orders/screens/order_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/providers/register_shop_provider.dart';
import 'package:foodpanda_seller/register_shop/screens/register_shop_screen.dart';
import 'package:provider/provider.dart';

import '../../customers/customers_screen.dart';
import '../../order_history/screens/order_history_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = OrderController();
    final height = MediaQuery.of(context).size.height;

    final ap = context.watch<AuthenticationProvider>();
    final rp = context.watch<RegisterShopProvider>();

    return Scaffold(
      backgroundColor: Color(0xff041C32),
      appBar: AppBar(
        backgroundColor: Color(0xff041C32),
        title: const Text(
          'DS Finance',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
    //     actions: [
    //       IconButton(
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => QRViewExample(),
    //             ),
    //           );
    // },
    //         icon: const Icon(Icons.qr_code_2_rounded),
    //       ),
    //     ],
        centerTitle: true,
      ),
      drawer: MyDrawer(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${ap.name}',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(

              children: [

                collageItem(
                  height: height,
                  iconData: Icons.money_outlined,
                  title: 'اضافه انواع',
                  onTap: () {
                    if (rp.isRegistered) {
                      Navigator.pushNamed(context, MenuScreen.routeName);
                    } else {
                      Navigator.pushNamed(
                          context, RegisterShopScreen.routeName);
                    }
                  },
                ),
                const SizedBox(width: 8),
                collageItem(
                  height: height,
                  iconData: Icons.history,
                  title: 'سجل الطلبات',
                  onTap: () {

    Navigator.pushNamed(context, OrderHistoryScreen.routeName);


                  },
                ),

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.person_outlined,
                  title: 'سجل العملاء ',
                  onTap: () {
                    if (rp.isRegistered) {
                     Navigator.push (context, MaterialPageRoute(builder: (context)=>const CustomersScreen()));
                    } else {
                      Navigator.pushNamed(
                          context, RegisterShopScreen.routeName);
                    }
                  },
                ),
                const SizedBox(width: 8),
                ap.isSignedIn
                    ? StreamBuilder<List<Order>>(
                        stream: orderController.fetchOrder(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading');
                          }
                          return
                              // final food = snapshot.data![index];
                              collageItem(
                            height: height,
                            iconData: Icons.shopping_cart_outlined,
                            title: 'الطلبات الوارده',
                            onTap: () {
                              if (rp.isRegistered) {
                                Navigator.pushNamed(
                                    context, OrderScreen.routeName);
                              } else {
                                Navigator.pushNamed(
                                    context, RegisterShopScreen.routeName);
                              }
                            },
                            alert: snapshot.data == null
                                ? 0
                                : snapshot.data!.length,
                          );
                        })
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded collageItem({
    required double height,
    required IconData iconData,
    required String title,
    required VoidCallback onTap,
    int alert = 0,
  }) {
    return Expanded(
      child: InkWell(
        splashColor: scheme.primary.withOpacity(0.2),
        onTap: onTap,
        child: Ink(
          height: height * 0.17,
          decoration: BoxDecoration(
            color: Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                alert > 0
                    ? Positioned(
                        top: 20,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: scheme.primary,
                          radius: 13,
                          child: Text(
                            alert.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      iconData,
                      color: Color(0xffECB365),
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
