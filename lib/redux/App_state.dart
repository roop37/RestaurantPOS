import 'package:management/models/table.model.dart';


class AppState {
  final List<TableModel> tables;

  AppState({required this.tables});

  factory AppState.initialState() {
    final List<TableModel> initialTables = List.generate(8, (index) {
      return TableModel.vacant(index + 1);
    });

    return AppState(tables: initialTables);
  }
}
