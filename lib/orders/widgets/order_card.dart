import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/widgets/text_tag.dart';
import 'package:foodpanda_seller/models/order.dart';
import 'package:foodpanda_seller/orders/widgets/view_detail.dart';
import 'package:foodpanda_seller/widgets/my_alert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback acceptOrder;
  final VoidCallback cancelOrder;
  bool? isHistoryOrder;
  OrderCard({
    super.key,
    required this.order,
    required this.acceptOrder,
    required this.cancelOrder,

    this.isHistoryOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: Color(0xffECB365)
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.id}',
                            style: TextStyle(
                              fontSize: isHistoryOrder! ? 13 : 16,
                              color: Color(0xffECB365),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: isHistoryOrder! ? 5 : 0),
                        isHistoryOrder!
                            ? TextTag(
                                text: order.isCancelled
                                    ? 'Cancelled'
                                    : order.isShopAccept
                                        ? 'Complete'
                                        : 'Progress',
                                backgroundColor: order.isDelivered
                                    ? scheme.primary
                                    : Colors.white,
                                textColor: order.isDelivered
                                    ? Colors.white
                                    : scheme.primary,
                                borderColor: scheme.primary,
                              )
                            : const SizedBox()
                      ],
                    ),
                    Text(
                      DateFormat.jm()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                        order.time,
                      )),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffECB365),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Customer: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  order.user.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              // GestureDetector(
              //   onTap: () async {
              //     if (order.user.phoneNumber != null) {
              //       Uri phoneNumber =
              //           Uri.parse('tel:+${order.user.phoneNumber}');
              //
              //       if (await launchUrl(phoneNumber)) {
              //         //dialer opened
              //       } else {
              //         //dailer is not opened
              //       }
              //     }
              //   },
              //   child: Icon(
              //     Icons.call_outlined,
              //     color: Color(0xffECB365),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          // هنا نوع الطلب سواء اذن صرف او عهدة

          Row(
            children: [
              const Text(
                'Type: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  order.user.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              // GestureDetector(
              //   onTap: () async {
              //     if (order.user.phoneNumber != null) {
              //       Uri phoneNumber =
              //           Uri.parse('tel:+${order.user.phoneNumber}');
              //
              //       if (await launchUrl(phoneNumber)) {
              //         //dialer opened
              //       } else {
              //         //dailer is not opened
              //       }
              //     }
              //   },
              //   child: Icon(
              //     Icons.call_outlined,
              //     color: Color(0xffECB365),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 5),
          // Padding(
          //   padding: const EdgeInsets.only(right: 20),
          //   child: Text(
          //     '${order.address.houseNumber} ${order.address.street} ${order.address.province}',
          //     style: TextStyle(
          //       fontSize: 14,
          //       color: Colors.grey[700],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Payment Method: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                order.foodOrders[0].customize,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Amount: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${order.totalPrice}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    order.isPaid ? '(Already paid)' : '(Not yet paid)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // وصف الطلب الليي اليوزر هيكتبه

          Row(
            children: [
              const Text(
                'Description: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' ${order.shop.shopDescription}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // تاريخ الطلب

          Row(
            children: [
              const Text(
                'Date: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${order.shop.shopDescription}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Mail: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' ${order.user.email}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // المرفقات
          Row(
            children: [
              const Text(
                'ِAttachment: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' ${order.shop.shopDescription}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),


          ViewDetail(order: order),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          !isHistoryOrder!
              ? !order.isShopAccept
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            text: 'رفض',
                            onPressed: cancelOrder,
                            isDisabled: false,
                            isOutlined: true,
                          ),
                        ),
                        Expanded(
                          child: CustomTextButton(
                            text: 'قبول',
                            onPressed: acceptOrder,
                            isDisabled: false,
                          ),
                        )
                      ],
                    )
                  : SizedBox()
              : const SizedBox(),
        ]),
      ),
    );
  }
}
