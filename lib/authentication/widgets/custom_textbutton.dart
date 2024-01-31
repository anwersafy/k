import 'package:flutter/material.dart';
import 'package:foodpanda_seller/constants/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  bool isOutlined;
  CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isDisabled,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey[400]
              : isOutlined
                  ? Colors.transparent
                  : Color(0xff064663),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isOutlined ? Colors.white: Colors.transparent,
            width: isOutlined ? 1 : 0,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isOutlined ?Color(0xff064663)  : Colors.white,
          ),
        ),
      ),
    );
  }
}
