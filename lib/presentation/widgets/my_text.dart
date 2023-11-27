import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  final String text;
  TextOverflow? textOverflow;
  TextAlign? textAlign;
  int? maxLines;
  Color? textColor;
  double? textSize;
  FontStyle? textStyle;
  FontWeight? weight;
  TextStyle? style;
  MyText(
      {Key? key,
      required this.text,
      this.textAlign,
      this.textOverflow,
      this.maxLines,
      this.textColor,
      this.textSize,
      this.textStyle,
      this.weight,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: style != null
          ? style!
          : TextStyle(
              color: textColor,
              fontSize: textSize,
              fontStyle: textStyle,
              fontWeight: weight),
    );
  }
}
