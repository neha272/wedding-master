import 'package:flutter/material.dart';
import 'package:wedding/general/color_constants.dart';

class RoundedElevatedButton extends StatelessWidget {
  final Widget label;
  final Color? textColor;
  final Color? color;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  const RoundedElevatedButton(
      {Key? key,
      required this.label,
      this.color,
      this.fontWeight,
      required this.onPressed,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    width: 1.2,
                    color: grey.withOpacity(0.3),
                  )),
            ),
            backgroundColor: MaterialStateProperty.all(color ?? buttonBg),
          ),
          child: label,
        ));
  }
}
