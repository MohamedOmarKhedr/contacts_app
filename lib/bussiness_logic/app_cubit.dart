import 'package:easy_contacts/presentation/screens/contacts_screen/contacts_screen.dart';
import 'package:easy_contacts/presentation/screens/favorites_screen/favorites_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  bool isBottomSheet = false;
  IconData floatingActionButtonIcon = Icons.person_add;

  int currentIndex = 0;

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

  late Database database;

  void createDatabase() {
    openDatabase(
      "contacts.db",
      version: 1,
      onCreate: (db, version) {
        if (kDebugMode) {
          print("Database created");
        }

        db
            .execute(
                'CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, phoneNumber TEXT, type TEXT)')
            .then((value) {
          if (kDebugMode) {
            print("Table created");
          }
        }).catchError((error) {
          if (kDebugMode) {
            print("error while Table created: $error");
          }
        });
      },
      onOpen: (db) {
        // TODO: get contacts
        getContacts(db);
        if (kDebugMode) {
          print("Database opened");
        }
      },
    ).then((value) {
      database = value;
      emit(AppOpenDataBaseState());
    });
  }

  void getContacts(Database database) async {
    emit(AppLoadingDatabaseState());

    contacts.clear();
    favorites.clear();

    await database.rawQuery("SELECT * FROM contacts").then((value) {
      for (Map<String, Object?> element in value) {
        contacts.add(element);

        if (element['type'] == 'favorite') {
          favorites.add(element);
        }
      }
    });

    emit(AppDoneDatabaseState());
  }

  Future<void> insertContact(
      {required String name, required String phoneNumber}) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO contacts(name, phoneNumber, type) VALUES ("$name","$phoneNumber","all")');
    }).then((value) {
      if (kDebugMode) {
        print("Contact $value successfully insert!");
        emit(AppInsertContactDoneState());
        getContacts(database);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("error while contact inserted: $error");
      }
    });
  }

  Future<void> addOrRemoveFavorite(
      {required String type, required int id}) async {
    await database.rawUpdate(
        'UPDATE contacts SET type = ? WHERE id = ?', [type, id]).then((value) {
      getContacts(database);
      emit(AppaddOrRemoveFavoriteDoneState());
    });
  }

  Future<void> editContact(
      {required String name,
      required String phoneNumber,
      required int id}) async {
    await database.rawUpdate(
        'UPDATE contacts SET name = ?, phoneNumber = ?WHERE id = ?',
        [name, phoneNumber, id]).then((value) {
      getContacts(database);
      emit(AppEditContactDoneState());
    });
  }

  Future<void> deleteContact({required int id}) async {
    await database
        .rawDelete('DELETE FROM contacts WHERE id = ?', [id]).then((value) {
      getContacts(database);
      emit(AppDeleteContactDoneState());
    });
  }
}
