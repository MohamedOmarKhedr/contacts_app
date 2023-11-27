import 'package:easy_contacts/bussiness_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/views/contacts_lists_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Map> FavoritesList;

  @override
  void didChangeDependencies() {
    FavoritesList = AppCubit.get(context).favorites;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          color: Colors.green,
          child: ContactsListsBuilder(
            contacts: FavoritesList,
            contactType: 'favorite',
            noContacts: 'No inserted favorites yet ..',
          ),
        );
      },
    );
  }
}
