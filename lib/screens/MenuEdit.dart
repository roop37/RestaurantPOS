import 'package:flutter/material.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/menu.model.dart';
import 'package:gravitea_pos/screens/HomePage.dart';
import 'package:gravitea_pos/screens/ProfilePage.dart';
import 'package:gravitea_pos/storage/data_manager.dart';
import 'package:gravitea_pos/widgets/BottomNavB.dart';

class MenuEditPage extends StatefulWidget {
  @override
  _MenuEditPageState createState() => _MenuEditPageState();
}

class _MenuEditPageState extends State<MenuEditPage> {
  List<MenuItem> menuList = [];
  List<MenuItem> filteredMenuList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMenuData();
  }

  void fetchMenuData() async {
    List<MenuItem> fetchedMenu = await fetchMenuList();
    setState(() {
      menuList = fetchedMenu;
      filteredMenuList = menuList;
    });
  }

  void filterMenuList(String searchTerm) {
    setState(() {
      filteredMenuList = menuList
          .where((item) =>
          item.name!.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  // ... (existing code)

  void editMenuItem(MenuItem menuItem) async {
    // Show a popup with two text fields for name and price
    TextEditingController nameController = TextEditingController(text: menuItem.name);
    TextEditingController priceController = TextEditingController(text: menuItem.price.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Menu Item'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text;
                double newPrice = double.tryParse(priceController.text) ?? 0.0;

                if (newName.isNotEmpty && newPrice >= 0) {
                  final List<MenuItem> updatedMenuList = await fetchMenuList();
                  final int index = updatedMenuList.indexWhere((item) => item.name == menuItem.name);

                  if (index != -1) {
                    updatedMenuList[index].name = newName;
                    updatedMenuList[index].price = newPrice;

                    await updateMenuList(updatedMenuList);

                    // Update the UI
                    setState(() {
                      menuItem.name = newName;
                      menuItem.price = newPrice;
                    });
                  }

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMenuItem(MenuItem menuItem) async {
    try {
      List<MenuItem> currentMenu = await fetchMenuList();
      currentMenu.removeWhere((item) => item.name == menuItem.name);

      // Update the stored menu list
      await updateMenuList(currentMenu);

      // Trigger a UI update
      setState(() {
        menuList = currentMenu;
        filteredMenuList = menuList;
      });

      print('Deleting menu item: ${menuItem.name}');
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }





  void handleDelete(MenuItem menuItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${menuItem.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel the operation
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteMenuItem(menuItem); // Call deleteMenuItem with MenuItem
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void addMenuItem() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Menu Item'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text;
                double newPrice = double.tryParse(priceController.text) ?? 0.0;

                if (newName.isNotEmpty && newPrice >= 0) {
                  final List<MenuItem> updatedMenuList = await fetchMenuList();
                  updatedMenuList.add(MenuItem(name: newName, price: newPrice));

                  await updateMenuList(updatedMenuList);

                  // Update the UI
                  setState(() {
                    menuList = updatedMenuList;
                    filteredMenuList = menuList;
                  });

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Menus'),
        backgroundColor: AppColors.primaryColor, // Set app bar background color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterMenuList(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenuList.length,
              itemBuilder: (context, index) {
                final menuItem = filteredMenuList[index];

                return ListTile(
                  title: Text('${menuItem.name} -₹ ${menuItem.price} '),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editMenuItem(menuItem);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          handleDelete(menuItem);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addMenuItem();
          },
          child: const Icon(Icons.add),
          backgroundColor: AppColors.accentColor, // Set FAB background color
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: 1,
          onTabTapped: (int index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            }
          },
          backgroundColor: AppColors.primaryColor, // Set bottom navigation bar background color
        ),
      );
    }
}

