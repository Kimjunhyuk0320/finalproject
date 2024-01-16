import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/text_style.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget prefix;
  final Widget sufix;
  final Color? borderColor;
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.prefix,
      required this.sufix,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: controller,
        style: pSemiBold18.copyWith(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ConstColors.lightGrayColor,
          prefixIcon: prefix,
          suffixIcon: sufix,
          hintText: hintText,
          hintStyle: pRegular14.copyWith(
            color: ConstColors.greyColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: borderColor ?? ConstColors.borderColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextWithoutPrefixField extends StatelessWidget {
  final String hintText;
  final String title;
  final TextEditingController controller;
  final Widget? sufix;
  final Color? borderColor;
  const CustomTextWithoutPrefixField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.borderColor,
      this.sufix,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: pSemiBold20.copyWith(
            fontSize: 16,
            color: ConstColors.greyColor,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: controller,
            style: pSemiBold18.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ConstColors.lightGrayColor,
              suffixIcon: sufix,
              //  contentPadding: const EdgeInsets.only(left: 20),
              hintText: hintText,
              hintStyle: pRegular14.copyWith(
                color: ConstColors.greyColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextWithoutTitle extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? sufix;
  final Color? borderColor;
  const CustomTextWithoutTitle({
    super.key,
    required this.hintText,
    required this.controller,
    this.borderColor,
    this.sufix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: controller,
        style: pSemiBold18.copyWith(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ConstColors.lightGrayColor,
          suffixIcon: sufix,
          //  contentPadding: const EdgeInsets.only(left: 20),
          hintText: hintText,
          hintStyle: pRegular14.copyWith(
            color: ConstColors.borderColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
