import 'package:easy_contacts/bussiness_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/views/edit_contact_dialog.dart';
import 'package:easy_contacts/presentation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsListsItem extends StatelessWidget {
  final Map contactModel;
  const ContactsListsItem({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        await AppCubit.get(context).deleteContact(id: contactModel['id']);
        Fluttertoast.showToast(
            msg: "contact delete successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: darkBlue,
            fontSize: 14.sp);
      },
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(
              msg:
                  "long taouch for editing contact, swip left or right to delete contact, double touch for calling contact",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 10,
              backgroundColor: darkBlue,
              textColor: white,
              fontSize: 14.sp);
        },
        onLongPress: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => EditContactDialog(contactModel: contactModel),
          );
        },
        onDoubleTap: () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: contactModel['phoneNumber'],
          );
          await launchUrl(launchUri);
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 2.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.sp),
              gradient: LinearGradient(colors: [
                Colors.blue[500]!,
                Colors.blue[300]!,
                Colors.blue[500]!
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 2.w),
                    child: MyText(
                      text: "${contactModel['name']}",
                      textSize: 14.sp,
                      weight: FontWeight.bold,
                      maxLines: 1,
                      textColor: white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 2.w),
                    child: MyText(
                      text: "${contactModel['phoneNumber']}",
                      textSize: 14.sp,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textColor: white,
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: contactModel['type'] == "favorite",
                  replacement: IconButton(
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                    ),
                    onPressed: () async {
                      await AppCubit.get(context).addOrRemoveFavorite(
                          type: "favorite", id: contactModel['id']);
                    },
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await AppCubit.get(context).addOrRemoveFavorite(
                          type: "all", id: contactModel['id']);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
