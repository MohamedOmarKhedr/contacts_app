import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatefulWidget {
  bool? obscureText;
  final String? hintText;
  final String? labelText;
  final TextInputType textInputType;
  final Widget prefixIcon;
  String? Function(String?) validate;
  final TextEditingController controller;
  Color? borderColor;
  Color? textColor;

  MyTextFormField(
      {Key? key,
      this.obscureText = false,
      required this.controller,
      this.labelText = '',
      this.hintText = '',
      required this.textInputType,
      required this.prefixIcon,
      required this.validate,
      this.borderColor = Colors.black,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  State<MyTextFormField> createState() => _MyTextFornFeildState();
}

class _MyTextFornFeildState extends State<MyTextFormField> {
  late final bool _isHiding;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._isHiding = widget.obscureText!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 2.5.w),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText!,
        keyboardType: widget.textInputType,
        scrollPhysics: ScrollPhysics(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusColor: widget.textColor,
          prefixIcon: widget.prefixIcon,
          suffixIcon: this._isHiding == true
              ? IconButton(
                  icon: widget.obscureText == false
                      ? Icon(Icons.remove_red_eye)
                      : Icon(Icons.visibility_off_sharp),
                  onPressed: () {
                    setState(() {
                      widget.obscureText == true
                          ? widget.obscureText = false
                          : widget.obscureText = true;
                    });
                  },
                )
              : SizedBox(),
          label: Text("${widget.labelText}"),
          hintText: widget.hintText!,
          labelStyle: TextStyle(color: widget.textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: widget.borderColor!, width: .5.w),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: widget.borderColor!, width: .5.w)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: widget.borderColor!, width: .5.w)),
        ),
        validator: widget.validate,
      ),
    );
  }
}
