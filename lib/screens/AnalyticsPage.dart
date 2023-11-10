import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:management/models/OrderDetails.model.dart';
import 'package:management/models/orderItem.model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';


class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<OrderDetails> orderList = [];
  Queue<double> weeklyEarningsQueue = Queue<double>();


  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is initialized
    fetchOrdersFromLocalStorage();
  }

  Future<void> fetchOrdersFromLocalStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> storedOrders = prefs.getStringList('orderList') ?? [];

      setState(() {
        orderList = storedOrders
            .map((orderJson) =>
            OrderDetails.fromJson(json.decode(orderJson)))
            .toList();
      });
      print('Successfully fetched orders: $orderList');
    } catch (e) {
      print('Error fetching order data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailyEarningsComparisonContent(),
              _buildAverageWeeklyEarningsContent(),
              _buildCard(
                title: 'Average Monthly Earnings',
                content: _buildMonthlyAverageEarnings(),
              ),
              _buildTop5Content(),
              _buildTop5BusiestTimeOfDayContent(),
              _buildCard(
                title: 'Average Order Value',
                content: _buildAverageOrderValueContent(),
              ),
              _buildCard(
                title: 'Customer Frequency',
                content: _buildCustomerFrequencyContent(),
              ),
              _buildCard(
                title: 'Flagged Order Statistics',
                content: _buildFlaggedOrderStatisticsContent(),
              ),

              _buildCard(
                title: 'Transaction Type Distribution',
                content: _buildTransactionTypeDistributionContent(),
              ),
              _buildCard(
                title: 'Order Type Distribution',
                content: _buildOrderTypeDistributionContent(),
              ),
              // Add other analytics widgets here
            ],
          ),
        ),
      ),
    );
  }






  Color getColor() {
    // You can customize the colors based on your preference
    // For simplicity, we're using random colors here
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1,
    );
  }

  final Random _random = Random();

  double calculateAverageYearlyEarnings() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    List<int> years = orderList.map((order) => order.date.year).toList();

    Map<int, double> yearlyEarnings = {};
    for (int year in years) {
      double totalEarnings = orderList
          .where((order) => order.date.year == year)
          .fold(0.0, (sum, order) => sum + order.totalBill);
      yearlyEarnings[year] = totalEarnings;
    }

    double averageYearlyEarnings =
        yearlyEarnings.values.reduce((sum, earnings) => sum + earnings) /
            yearlyEarnings.length;

    return averageYearlyEarnings;
  }
  // Add this method to the _AnalyticsPageState class
  void updateWeeklyEarningsQueue() {
    // Calculate the average weekly earnings
    double averageWeeklyEarnings = calculateAverageWeeklyEarnings();

    // Update the queue with the latest data
    weeklyEarningsQueue.addLast(averageWeeklyEarnings);

    // Keep only the last 4 weeks' data in the queue
    while (weeklyEarningsQueue.length > 4) {
      weeklyEarningsQueue.removeFirst();
    }
  }
  double calculateAverageWeeklyEarnings() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    List<DateTime> orderDates = orderList.map((order) => order.date).toList();

    Map<int, double> weeklyEarnings = {};
    for (DateTime date in orderDates) {
      // Calculate ISO week number to group by week
      int isoWeekNumber = DateTime(date.year, date.month, date.day)
          .toUtc()
          .weekday; // Assuming the week starts on Monday

      double totalEarnings = orderList
          .where((order) =>
      DateTime(order.date.year, order.date.month, order.date.day)
          .toUtc()
          .weekday ==
          isoWeekNumber)
          .fold(0.0, (sum, order) => sum + order.totalBill);
      weeklyEarnings[isoWeekNumber] = totalEarnings;
    }

    double averageWeeklyEarnings =
        weeklyEarnings.values.reduce((sum, earnings) => sum + earnings) /
            weeklyEarnings.length;

    return averageWeeklyEarnings;
  }
  double getLastWeekAverageWeeklyEarnings() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    int currentIsoWeekNumber = DateTime.now().toUtc().subtract(Duration(days: DateTime.now().weekday)).weekday;

    int lastWeekIsoWeekNumber = currentIsoWeekNumber > 1
        ? currentIsoWeekNumber - 1
        : 7;

    List<OrderDetails> lastWeekOrders = orderList
        .where((order) =>
    DateTime(order.date.year, order.date.month, order.date.day).toUtc().weekday == lastWeekIsoWeekNumber)
        .toList();

    if (lastWeekOrders.isEmpty) {
      return 0.0;
    }

    double totalEarnings = lastWeekOrders.fold(0.0, (sum, order) => sum + order.totalBill);

    double averageWeeklyEarnings = totalEarnings / lastWeekOrders.length;

    return averageWeeklyEarnings;
  }


  Widget _buildAverageWeeklyEarningsContent() {
    double averageWeeklyEarnings = calculateAverageWeeklyEarnings();
    double lastWeekAverageWeeklyEarnings = getLastWeekAverageWeeklyEarnings();

    // Call the method to build the chart
    Widget chartWidget = _buildWeeklyEarningsLineChart();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Weekly Earnings:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'This Week\'s Total: ',
                ),
                Text(
                  '${averageWeeklyEarnings.toStringAsFixed(2)} INR',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Display the chart
            chartWidget,
            SizedBox(height: 16.0),
            // Compare this week's total with last week's total
            Text(
              'Last Week\'s Total Earnings:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${lastWeekAverageWeeklyEarnings.toStringAsFixed(2)} INR',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Comparison:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${compareWeeklyEarnings(averageWeeklyEarnings, lastWeekAverageWeeklyEarnings)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

// Add this method to compare weekly earnings
  String compareWeeklyEarnings(double currentWeekEarnings, double lastWeekEarnings) {
    if (currentWeekEarnings > lastWeekEarnings) {
      return 'This week\'s earnings are higher than last week.';
    } else if (currentWeekEarnings < lastWeekEarnings) {
      return 'This week\'s earnings are lower than last week.';
    } else {
      return 'This week\'s earnings are the same as last week.';
    }
  }



// Add this method to create the line chart
  Widget _buildWeeklyEarningsLineChart() {
    List<FlSpot> spots = _getWeeklyEarningsSpots();

    return Container(
      height: 150,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],

          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

// Helper method to get data for the line chart
  List<FlSpot> _getWeeklyEarningsSpots() {
    List<DateTime> orderDates = orderList.map((order) => order.date).toList();
    Map<int, double> weeklyEarnings = {};

    for (DateTime date in orderDates) {
      int isoWeekNumber = DateTime(date.year, date.month, date.day).toUtc().weekday;
      double totalEarnings = orderList
          .where((order) => DateTime(order.date.year, order.date.month, order.date.day).toUtc().weekday == isoWeekNumber)
          .fold(0.0, (sum, order) => sum + order.totalBill);
      weeklyEarnings[isoWeekNumber] = totalEarnings;
    }

    // Convert the map to a list of FlSpot
    List<FlSpot> spots = weeklyEarnings.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();

    return spots;
  }

  Map<String, double> calculateTopMenuItems() {
    if (orderList.isEmpty) {
      return {};
    }

    Map<String, double> menuItemsQuantity = {};

    for (OrderDetails order in orderList) {
      for (OrderItem item in order.orderItems) {
        menuItemsQuantity[item.menuItem] =
            (menuItemsQuantity[item.menuItem] ?? 0) + item.quantity;
      }
    }

    // Sort the menu items by total quantity sold in descending order
    List<MapEntry<String, double>> sortedMenuItems =
    menuItemsQuantity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take the top 5 menu items
    Map<String, double> top5MenuItems = {};
    for (int i = 0; i < 5 && i < sortedMenuItems.length; i++) {
      top5MenuItems[sortedMenuItems[i].key] = sortedMenuItems[i].value;
    }

    return top5MenuItems;
  }



  Widget _buildTop5Content() {
    Map<String, double> top5MenuItems = calculateTopMenuItems();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Top 5 Menu Items:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            if (top5MenuItems.length >= 5) // Check if there are enough items
              Column(
                children: [
                  Container(
                    height: 150, // Set a fixed height for the chart
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: calculateMaxEarnings(top5MenuItems.values.toList()),

                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: top5MenuItems.values.toList()[0],
                                color: getColor(), // Customize the color
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: top5MenuItems.values.toList()[1],
                                color: getColor(), // Customize the color
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: top5MenuItems.values.toList()[2],
                                color: getColor(), // Customize the color
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: top5MenuItems.values.toList()[3],
                                color: getColor(), // Customize the color
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: top5MenuItems.values.toList()[4],
                                color: getColor(), // Customize the color
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: top5MenuItems.entries
                        .map(
                          (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '(${top5MenuItems.keys.toList().indexOf(entry.key) + 1})',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            Text(entry.key),
                            Text('Sold: ${entry.value.toInt()}'), // Display the total number sold
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              )
            else
              Text('Not enough data available. Minimum 5 menu items are required.'),
          ],
        ),
      ),
    );
  }

  double calculateMaxEarnings(List<double> values) {
    return values.isNotEmpty ? values.reduce((max, value) => max > value ? max : value) : 0.0;
  }

  Widget _buildTop5BusiestTimeOfDayContent() {
    Map<int, int> top5BusiestTimes = calculateTop5BusiestTimeOfDay();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Top 5 Busiest Times of Day:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            if (top5BusiestTimes.isNotEmpty)
              Column(
                children: top5BusiestTimes.entries
                    .map(
                      (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${top5BusiestTimes.keys.toList().indexOf(entry.key) + 1})',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '${entry.key}:30 - ${(entry.key + 1) % 24}:00',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text('${entry.value} orders'),
                      ],
                    ),
                  ),
                )
                    .toList(),
              )
            else
              Text('No data available.'),
          ],
        ),
      ),
    );
  }


  Map<int, int> calculateTop5BusiestTimeOfDay() {
    if (orderList.isEmpty) {
      return {};
    }

    Map<int, int> orderCountByHalfHour = {};

    for (OrderDetails order in orderList) {
      final orderHour = order.date.hour;
      final orderMinute = order.date.minute;
      final halfHour = (orderMinute < 30) ? orderHour : (orderHour + 1) % 24;

      if (orderCountByHalfHour.containsKey(halfHour)) {
        orderCountByHalfHour[halfHour] = orderCountByHalfHour[halfHour]! + 1;
      } else {
        orderCountByHalfHour[halfHour] = 1;
      }
    }

    // Sort the half-hour intervals by order count in descending order
    List<MapEntry<int, int>> sortedBusiestTimes =
    orderCountByHalfHour.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take the top 5 busiest half-hour intervals
    Map<int, int> top5BusiestTimes = {};
    for (int i = 0; i < 5 && i < sortedBusiestTimes.length; i++) {
      top5BusiestTimes[sortedBusiestTimes[i].key] = sortedBusiestTimes[i].value;
    }

    return top5BusiestTimes;
  }



  Widget _buildAverageOrderValueContent() {
    double averageOrderValue = calculateAverageOrderValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Average Order Value:'),
        Text(
          '${averageOrderValue.toStringAsFixed(2)} INR',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  double calculateAverageOrderValue() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    double totalOrderValue = orderList.fold(0.0, (sum, order) => sum + order.totalBill);
    return totalOrderValue / orderList.length;
  }
  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            content,
          ],
        ),
      ),
    );
  }
  Widget _buildCustomerFrequencyContent() {
    Map<String, int> customerFrequencyMap = calculateCustomerFrequency();
    List<MapEntry<String, int>> sortedFrequencies = sortCustomerFrequencies(customerFrequencyMap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 3 && i < sortedFrequencies.length; i++)
          Text(
            '${sortedFrequencies[i].key}: ${sortedFrequencies[i].value} orders',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Map<String, int> calculateCustomerFrequency() {
    Map<String, int> customerFrequencyMap = {};

    for (OrderDetails order in orderList) {
      if (order.name.isNotEmpty) {
        customerFrequencyMap.update(
          order.name,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return customerFrequencyMap;
  }

  List<MapEntry<String, int>> sortCustomerFrequencies(Map<String, int> frequencyMap) {
    List<MapEntry<String, int>> sortedEntries = frequencyMap.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  Widget _buildFlaggedOrderStatisticsContent() {
    int totalFlaggedOrders = calculateTotalFlaggedOrders();
    double flaggedOrdersPercentage = calculateFlaggedOrdersPercentage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Flagged Orders: $totalFlaggedOrders'),
        Text('Flagged Orders Percentage: ${flaggedOrdersPercentage.toStringAsFixed(2)}%'),
      ],
    );
  }

  int calculateTotalFlaggedOrders() {
    int flaggedOrdersCount = 0;

    for (OrderDetails order in orderList) {
      if (order.isFlagged) {
        flaggedOrdersCount++;
      }
    }

    return flaggedOrdersCount;
  }

  double calculateFlaggedOrdersPercentage() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    int flaggedOrdersCount = calculateTotalFlaggedOrders();
    return (flaggedOrdersCount / orderList.length) * 100;
  }

  Widget _buildTransactionTypeDistributionContent() {
    Map<String, int> transactionTypeCounts = calculateTransactionTypeDistribution();
    int totalOrders = orderList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var entry in transactionTypeCounts.entries)
          Column(
            children: [
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${entry.key}: ${entry.value}'),
                ],
              ),
              SizedBox(height: 5,),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: entry.value / totalOrders,
                progressColor: Colors.blue,
              ),
            ],
          ),
      ],
    );
  }

  Map<String, int> calculateTransactionTypeDistribution() {
    Map<String, int> transactionTypeCounts = {};

    for (OrderDetails order in orderList) {
      String transactionType = order.transactionType;
      transactionTypeCounts[transactionType] =
          (transactionTypeCounts[transactionType] ?? 0) + 1;
    }

    return transactionTypeCounts;
  }



  Widget _buildOrderTypeDistributionContent() {
    Map<String, int> orderTypeCountMap = calculateOrderTypeDistribution();
    int totalOrders = orderList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: orderTypeCountMap.entries.map((entry) {
        String orderType = entry.key;
        int orderCount = entry.value;
        double orderPercentage = (orderCount / totalOrders) * 100;

        return Column(
          children: [
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$orderType: $orderCount Orders'),
              ],
            ),
            SizedBox(height: 5,),
            LinearPercentIndicator(
              lineHeight: 9.0,
              percent: orderPercentage / 100,
              progressColor: Colors.blue,
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, int> calculateOrderTypeDistribution() {
    Map<String, int> orderTypeCountMap = {};

    for (OrderDetails order in orderList) {
      String orderType = order.orderType;
      orderTypeCountMap.update(orderType, (value) => value + 1, ifAbsent: () => 1);
    }

    return orderTypeCountMap;
  }

  // Inside the _AnalyticsPageState class

  Widget _buildMonthlyAverageEarnings() {
    double thisMonthAverage = _calculateThisMonthAverage();
    double lastMonthAverage = calculateLastMonthAverage();

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('This month: ${thisMonthAverage.toStringAsFixed(2)} INR'),
            _buildComparisonChart(thisMonthAverage, lastMonthAverage),
            Text('Last Month Average Earning: ${lastMonthAverage.toStringAsFixed(2)} INR'),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart(double thisMonthAverage, double lastMonthAverage) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: thisMonthAverage,
                  color: Colors.blue,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: lastMonthAverage,
                  color: Colors.red,
                ),
              ],
            ),
          ],

        ),
      ),
    );
  }
  double _calculateThisMonthAverage() {
    double sum = 0.0;
  int orderCount = 0;

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;

  for (OrderDetails order in orderList) {
    if (order.date.month == currentMonth && order.date.year == currentYear) {
      sum += order.totalBill;
      orderCount++;
    }
  }

  return orderCount > 0 ? sum / orderCount : 0.0;
  }

  double calculateLastMonthAverage() {
    double sum = 0.0;
    int orderCount = 0;

    DateTime now = DateTime.now();
    DateTime lastMonthStart;
    DateTime lastMonthEnd;

    // Handle cases where the current month is January
    if (now.month == 1) {
      lastMonthStart = DateTime(now.year - 1, 12, 1);
      lastMonthEnd = DateTime(now.year - 1, 12, 31);
    } else {
      lastMonthStart = DateTime(now.year, now.month - 1, 1);
      lastMonthEnd = DateTime(now.year, now.month, 0);
    }

    for (OrderDetails order in orderList) {
      if (order.date.isAfter(lastMonthStart) && order.date.isBefore(lastMonthEnd)) {
        sum += order.totalBill;
        orderCount++;
      }
    }

    return orderCount > 0 ? sum / orderCount : 0.0;
  }

  double getTodayAverageEarnings() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    DateTime today = DateTime.now().toUtc();

    List<OrderDetails> todayOrders = orderList
        .where((order) =>
    order.date.year == today.year &&
        order.date.month == today.month &&
        order.date.day == today.day)
        .toList();

    if (todayOrders.isEmpty) {
      return 0.0;
    }

    double totalEarnings =
    todayOrders.fold(0.0, (sum, order) => sum + order.totalBill);

    double averageEarnings = totalEarnings / todayOrders.length;

    return averageEarnings;
  }


  Widget _buildTodayYesterdayComparisonChart(double todayEarnings, double yesterdayEarnings) {
    return Container(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: todayEarnings,
                  color: Colors.blue,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: yesterdayEarnings,
                  color: Colors.green,
                ),
              ],
            ),
          ],

          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }

  double getYesterdayAverageEarnings() {
    if (orderList.isEmpty) {
      return 0.0;
    }

    // Calculate the date for yesterday
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    // Filter orders that occurred yesterday
    List<OrderDetails> yesterdayOrders = orderList
        .where((order) =>
    order.date.year == yesterday.year &&
        order.date.month == yesterday.month &&
        order.date.day == yesterday.day)
        .toList();

    if (yesterdayOrders.isEmpty) {
      return 0.0;
    }

    // Calculate total earnings for yesterday
    double totalEarnings =
    yesterdayOrders.fold(0.0, (sum, order) => sum + order.totalBill);

    // Calculate average earnings for yesterday
    double averageEarnings = totalEarnings / yesterdayOrders.length;

    return averageEarnings;
  }


  Widget _buildDailyEarningsComparisonContent() {
    // Call the method to build the chart comparing today's and yesterday's earnings
    Widget chartWidget = _buildTodayYesterdayComparisonChart(
      getTodayAverageEarnings(),
      getYesterdayAverageEarnings(),
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Today\'s vs Yesterday\'s Earnings:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'Today\'s Average: ',
                ),
                Text(
                  '${getTodayAverageEarnings().toStringAsFixed(2)} INR',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            chartWidget,
            Text(
              'Yesterday\'s Average Earnings:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${getYesterdayAverageEarnings().toStringAsFixed(2)} INR',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }




}

