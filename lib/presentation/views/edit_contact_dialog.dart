// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_contacts/bussiness_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../widgets/default_text_button.dart';
import '../widgets/my_text_form_feild.dart';

class EditContactDialog extends StatefulWidget {
  final Map contactModel;
  const EditContactDialog({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  @override
  State<EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController =
      TextEditingController(text: widget.contactModel['name']);

  late final TextEditingController _phoneController = TextEditingController(
      text: widget.contactModel['phoneNumber'].toString().substring(3));

  CountryCode countryCode = CountryCode(name: 'EG', dialCode: '+20');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: darkSkyBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        color: darkSkyBlue,
        padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h, top: 4.h),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextFormField(
                  controller: _nameController,
                  labelText: 'Contact Name',
                  textInputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.title),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "can't empty";
                    }
                    return null;
                  },
                  borderColor: lightBlue,
                  textColor: lightBlue,
                ),
                MyTextFormField(
                  controller: _phoneController,
                  labelText: 'Contact Number',
                  hintText: 'eg. 123456789',
                  textInputType: TextInputType.text,
                  prefixIcon: CountryCodePicker(
                    onChanged: (countryCode) {
                      this.countryCode = countryCode;
                    },
                    initialSelection: 'EG',
                    favorite: const ['+20', 'EG'],
                  ),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "can't empty";
                    }
                    return null;
                  },
                  borderColor: lightBlue,
                  textColor: lightBlue,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await AppCubit.get(context).editContact(
                              name: _nameController.text,
                              phoneNumber:
                                  "${countryCode.dialCode} ${_phoneController.text}",
                              id: widget.contactModel['id']);
                          Fluttertoast.showToast(
                              msg: "contact save successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green[900],
                              textColor: darkBlue,
                              fontSize: 14.sp);
                          // ignore: use_build_context_synchronously
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: MyText(
                        text: "Save",
                        textColor: white,
                        weight: FontWeight.bold,
                        textSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    DefaultTextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: MyText(
                        text: "Cancel",
                        textColor: white,
                        weight: FontWeight.bold,
                        textSize: 14.sp,
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
