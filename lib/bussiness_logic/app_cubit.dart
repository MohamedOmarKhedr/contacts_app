import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_contacts/presentation/screens/contacts_screen/contacts_screen.dart';
import 'package:easy_contacts/presentation/screens/favorites_screen/favorites_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  bool isBottomSheet = false;
  IconData floatingActionButtonIcon = Icons.person_add;

  int currentIndex = 0;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<Widget> screens = [const ContactsScreen(), const FavoritesScreen()];
  List<String> titles = ['Contacts', 'Favorites'];

  void changeScreensIndex(int index) {
    currentIndex = index;
    emit(ChangeScreensIndex());
  }

  void changeBottomSheet(
      {required bool isBottomSheet,
      required IconData floatingActionButtonIcon}) {
    this.isBottomSheet = isBottomSheet;
    this.floatingActionButtonIcon = floatingActionButtonIcon;
    emit(ChangeBottomSheetState());
  }

  List<Map> contacts = [];
  List<Map> favorites = [];



  void createDatabase() {
    getContacts();
    getFavorites();
  }



  void getContacts() async {
    emit(AppGetContactsLoadingDatabaseState());

    await fireStore.collection('contacts').get().then((value) {
      contacts.clear();
      for (var element in value.docs) {
        contacts.add(element.data());
      }
      emit(AppGetContactsDoneDatabaseState());
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
        emit(AppGetContactsErrorDatabaseState());
      }
    });
  }

  void getFavorites() async {
    emit(AppGetFavoritesLoadingDatabaseState());

    await fireStore
        .collection('contacts')
        .where("type", isEqualTo: "favorite")
        .get()
        .then((value) {
      favorites.clear();
      for (var element in value.docs) {
        favorites.add(element.data());
      }
      emit(AppGetFavoritesDoneDatabaseState());
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
        emit(AppGetFavoritesErrorDatabaseState());
      }
    });
  }



  Future<void> insertContact(
      {required String name, required String phoneNumber}) async {
    int uniqueId = DateTime.now().microsecondsSinceEpoch;
    await fireStore.collection('contacts').doc(uniqueId.toString()).set({
      'id': uniqueId,
      'name': name,
      'phoneNumber': phoneNumber,
      'type': "all"
    }).then((value) {
      emit(AppInsertContactDoneState());
      getContacts();
      getFavorites();
    });
  }



  Future<void> addOrRemoveFavorite(
      {required String type, required int id}) async {
    await fireStore
        .collection('contacts')
        .doc(id.toString())
        .update({'type': type}).then((value) {
      emit(AppaddOrRemoveFavoriteDoneState());
      getContacts();
      getFavorites();
    });
  }



  Future<void> editContact(
      {required String name,
      required String phoneNumber,
      required int id}) async {
    await fireStore
        .collection('contacts')
        .doc(id.toString())
        .update({'name': name, 'phoneNumber': phoneNumber}).then((value) {
      emit(AppEditContactDoneState());
      getContacts();
      getFavorites();
    });
  }



  Future<void> deleteContact({required int id}) async {
    await fireStore
        .collection('contacts')
        .doc(id.toString())
        .delete()
        .then((value) {
      emit(AppDeleteContactDoneState());
      getContacts();
      getFavorites();
    });
  }
}
