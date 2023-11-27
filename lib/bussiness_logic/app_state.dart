part of 'app_cubit.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class ChangeScreensIndex extends AppState {}

class ChangeBottomSheetState extends AppState {}

class AppOpenDataBaseState extends AppState {}

class AppGetContactsLoadingDatabaseState extends AppState {}

class AppGetContactsDoneDatabaseState extends AppState {}

class AppGetContactsErrorDatabaseState extends AppState {}

class AppGetFavoritesLoadingDatabaseState extends AppState {}

class AppGetFavoritesDoneDatabaseState extends AppState {}

class AppGetFavoritesErrorDatabaseState extends AppState {}

class AppInsertContactDoneState extends AppState {}

class AppaddOrRemoveFavoriteDoneState extends AppState {}

class AppEditContactDoneState extends AppState {}

class AppDeleteContactDoneState extends AppState {}
