import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final VoidCallback onTap;
  final Color? borderColor;
  const CustomButton(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.width,
      required this.onTap,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 56,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          color: color ?? ConstColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: pBold.copyWith(
              fontSize: 14,
              color: textColor ?? ConstColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
