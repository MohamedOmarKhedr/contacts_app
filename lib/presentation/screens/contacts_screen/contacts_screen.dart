import 'package:easy_contacts/bussiness_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/views/contacts_lists_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late List<Map> contactsList;

  @override
  void didChangeDependencies() {
    contactsList = AppCubit.get(context).contacts;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          color: Colors.green,
          child: ContactsListsBuilder(
            contacts: contactsList,
            contactType: 'all',
            noContacts: 'No inserted contacts yet ..',
          ),
        );
      },
    );
  }
}
