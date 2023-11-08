import 'package:management/redux/actions.dart';
import 'package:management/redux/App_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is UpdateTableAction) {
    // Update the table state in the store
    final updatedTables = state.tables.map((table) {
      if (table.tableNumber == action.updatedTable.tableNumber) {
        return action.updatedTable;
      }
      return table;
    }).toList();

    return AppState(
      tables: updatedTables,
    );
  }
  return state;
}
