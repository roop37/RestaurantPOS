import 'package:flutter/material.dart';
import '../app_colors.dart'; // Import the color file

class TableWidget extends StatelessWidget {
  final int tableNumber;
  final bool isOccupied;
  final Color backgroundColor; // New parameter

  TableWidget({
    required this.tableNumber,
    required this.isOccupied,
    required this.backgroundColor, // Add the new parameter
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = isOccupied ? AppColors.tert : backgroundColor;
    String statusText = isOccupied ? 'Occupied' : 'Vacant';

    return Container(
      height: 80.0, // Increased height
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0), // Added margin
      decoration: BoxDecoration(
        color: statusColor, // Use the provided backgroundColor
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.primaryColor), // Add border color
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
