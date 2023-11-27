import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/views/contacts_lists_item.dart';
import 'package:easy_contacts/presentation/widgets/default_divider.dart';
import 'package:easy_contacts/presentation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContactsListsBuilder extends StatelessWidget {
  final List<Map> contacts;
  final String noContacts;
  final String contactType;

  const ContactsListsBuilder(
      {super.key,
      required this.contacts,
      required this.noContacts,
      required this.contactType});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: contacts.isNotEmpty,
        replacement: Center(
          child: Column(
            children: [
              Icon(
                Icons.no_accounts,
                color: white,
                size: 70.sp,
              ),
              MyText(
                text: noContacts,
                textColor: white,
                textSize: 30.sp,
              ),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: ListView.separated(
              itemBuilder: (context, i) =>
                  ContactsListsItem(contactModel: contacts[i]),
              separatorBuilder: (context, i) => const DefaultDivider(),
              itemCount: contacts.length),
        ));
  }
}
