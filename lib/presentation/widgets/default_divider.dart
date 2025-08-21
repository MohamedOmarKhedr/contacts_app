import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';

class DefaultDivider extends StatelessWidget {
  const DefaultDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Divider(
          height: 2.h,
          color: backgroundColor,
        ))
      ],
    );
  }
}
