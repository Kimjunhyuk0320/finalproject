import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';

class CustomBackIcon extends StatelessWidget {
  const CustomBackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ConstColors.darkGrayColor,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 7),
              child: Icon(
                Icons.arrow_back_ios,
                color: ConstColors.fontColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
