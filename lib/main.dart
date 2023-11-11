import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gravitea_pos/redux/App_state.dart';
import 'package:gravitea_pos/redux/reducers.dart';
import 'package:gravitea_pos/screens/HomePage.dart';
import 'package:redux/redux.dart';

import 'app_colors.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gravitea Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primaryColor,
          hintColor: AppColors.accentColor,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
