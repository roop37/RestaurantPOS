import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final int tableNumber;
  final bool isOccupied;

  TableWidget({required this.tableNumber, required this.isOccupied});

  @override
  Widget build(BuildContext context) {
    Color statusColor = isOccupied ? Colors.red : Colors.green;
    String statusText = isOccupied ? 'Occupied' : 'Vacant';

    return Container(
      height: 80.0, // Increased height
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0), // Added margin
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.0), // Padding for the first Text
              child: Text(
                'Table $tableNumber',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0), // Padding for the second Text
              child: Text(
                statusText,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
