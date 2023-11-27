import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_contacts/bussiness_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/widgets/default_text.dart';
import 'package:easy_contacts/presentation/widgets/my_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late AppCubit _cubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  CountryCode countryCode = CountryCode(name: 'EG', dialCode: '+20');

  @override
  void didChangeDependencies() {
    _cubit = AppCubit.get(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppInsertContactDoneState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: darkSkyBlue,
                centerTitle: true,
                elevation: 8.0,
                title: DefaultText(
                    text: _cubit.titles[_cubit.currentIndex],
                    textColor: Colors.lightBlue,
                    weight: FontWeight.bold,
                    textSize: 20.sp),
              ),
              body: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [skyBlue, lightSkyBlue, skyBlue]),
                  ),
                ),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    if (state is AppGetContactsLoadingDatabaseState ||
                        state is AppGetFavoritesLoadingDatabaseState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green[900],
                        ),
                      );
                    }
                    if (state is AppGetContactsErrorDatabaseState ||
                        state is AppGetFavoritesErrorDatabaseState) {
                      return Icon(Icons.error, size: 50.sp);
                    } else {
                      return _cubit.screens[_cubit.currentIndex];
                    }
                  },
                )
              ]),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: darkSkyBlue,
                  selectedItemColor: lightSkyBlue,
                  unselectedItemColor: lightBlue,
                  elevation: 0,
                  currentIndex: _cubit.currentIndex,
                  onTap: (index) => _cubit.changeScreensIndex(index),
                  items: [
                    BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.contacts_outlined,
                        ),
                        label: _cubit.titles[0]),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.favorite), label: _cubit.titles[1]),
                  ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (_cubit.isBottomSheet) {
                    if (_formKey.currentState!.validate()) {
                      await _cubit.insertContact(
                          name: _nameController.text,
                          phoneNumber:
                              "${countryCode.dialCode} ${_phoneController.text}");
                      _nameController.text = '';
                      _phoneController.text = '';
                    }
                  } else {
                    _cubit.changeBottomSheet(
                        isBottomSheet: true,
                        floatingActionButtonIcon: Icons.add_box_outlined);

                    _scaffoldKey.currentState!
                        .showBottomSheet((context) => Wrap(
                              children: [
                                Container(
                                  color: darkSkyBlue,
                                  padding: EdgeInsets.only(
                                      left: 3.w,
                                      right: 3.w,
                                      bottom: 2.h,
                                      top: 4.h),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                        ]),
                                  ),
                                ),
                              ],
                            ))
                        .closed
                        .then((value) => _cubit.changeBottomSheet(
                            isBottomSheet: false,
                            floatingActionButtonIcon: Icons.person_add));
                  }
                },
                backgroundColor: darkSkyBlue,
                elevation: 20,
                child: Icon(
                  _cubit.floatingActionButtonIcon,
                  color: lightBlue,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
