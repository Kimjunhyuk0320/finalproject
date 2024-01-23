import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/text_style.dart';

// 커스텀 텍스트 필드
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget prefix;
  final Widget sufix;
  final Color? borderColor;
  final void Function(String)? onChanged;       // 변화를 감지할 때 사용
  final bool obscureText;                       // 비밀번호와 같이 사용자에게 보여지면 안될 때 사용
  final TextInputType keyboardType;

  // 선택적 매개변수에 기본값 false 설정
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.prefix,
    required this.sufix,
    this.borderColor,
    this.onChanged,
    this.obscureText = false,                   // 참일 때 입력창에 보여지지 않음.
    this.keyboardType = TextInputType.text,     // 평소에는 일반 키보드가 나온다.
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
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
  final bool obscureText;
  final bool readOnly;
  
  const CustomTextWithoutPrefixField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.borderColor,
      this.sufix,
      required this.title, 
      this.obscureText = false,
      this.readOnly = false});

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
            readOnly: readOnly,
            obscureText: obscureText,
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
