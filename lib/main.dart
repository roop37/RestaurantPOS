import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:management/redux/App_state.dart';
import 'package:management/redux/reducers.dart';
import 'package:management/screens/HomePage.dart';
import 'package:redux/redux.dart';

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
        ),
        home: HomeScreen(),
      ),
    );
  }
}
