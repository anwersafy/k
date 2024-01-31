import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodpanda_seller/address/screens/address_screen.dart';
import 'package:foodpanda_seller/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/order_history/screens/order_history_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/register_shop/screens/register_shop_screen.dart';
import 'package:foodpanda_seller/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const MyDrawer({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final ap = context.read<AuthenticationProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (c) {
            return DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  border: Border.all(color:Colors.grey.shade600),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          ap.name!.isNotEmpty ? ap.name!.substring(0, 1) : 'DS',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RegisterShopScreen.routeName);
                      },
                      child: Text(
                        ap.name!.isNotEmpty ? ap.name! : 'Ds Finance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ));
          }),





          Builder(builder: (c) {
            return listTile(
              context,
              'تسجيل الخروج',
              Icons.login_outlined,
              () {
                Scaffold.of(c).closeDrawer();
                showDialog(
                  context: c,
                  builder: (ctx) => MyAlertDialog(
                    title: 'تسجيل الخروج',
                    subtitle: 'هل انت متأكد من تسجيل الخروج؟',
                    action1Name: 'الغاء',
                    action2Name: 'تسجيل الخروج',
                    action1Func: () {
                      Navigator.pop(ctx);
                    },
                    action2Func: () async {
                      await ap.userSignOut();

                      Navigator.pushNamedAndRemoveUntil(ctx,
                          AuthenticationScreen.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }

  ListTile listTile(
      BuildContext context, String text, IconData? icon, VoidCallback onTap) {
    return icon == null
        ? ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            onTap: onTap,
          )
        : ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            leading: Icon(
              icon,
              color: scheme.primary,
            ),
            onTap: onTap,
          );
  }
}
