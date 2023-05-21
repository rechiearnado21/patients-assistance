import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final double height;
  final double width;
  final Color textColor;
  final bool isDisabled;
  final Color backgroundColor;
  final double? borderRadius;
  const PrimaryButton(
      {Key? key,
      required this.text,
      required this.height,
      required this.width,
      required this.textColor,
      required this.onTap,
      required this.isDisabled,
      this.borderRadius,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 30),
                color: isDisabled
                    ? backgroundColor.withOpacity(0.5)
                    : backgroundColor,
              ),
              child: Center(
                child: AutoSizeText(
                  text,
                  maxLines: 1,
                  maxFontSize: 13,
                  minFontSize: 8,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
