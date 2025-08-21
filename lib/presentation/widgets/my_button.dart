import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? elevation;
  final Color? backgroundColor;
  final Color? splashColor;
  final EdgeInsets? internalPadding;
  final double borderRadius;
  final Widget? child;
  final double height;
  final double width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const MyButton({super.key,required this.onPressed,this.elevation,this.backgroundColor=Colors.deepOrange,
    this.splashColor,this.internalPadding,this.borderRadius=10,this.child
  ,this.width=double.infinity,this.height=50,this.margin,this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      child: MaterialButton(onPressed: onPressed,
      elevation:elevation ,
      color: backgroundColor,
      splashColor:splashColor ,
      padding: internalPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child:child ,),
    );
  }
}
