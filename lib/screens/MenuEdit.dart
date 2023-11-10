import 'package:flutter/material.dart';
import 'package:management/models/menu.model.dart';
import 'package:management/screens/HomePage.dart';
import 'package:management/screens/ProfilePage.dart';
import 'package:management/storage/data_manager.dart';
import 'package:management/widgets/BottomNavB.dart';

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
          title: Text('Edit Menu Item'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
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
              child: Text('Confirm'),
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
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${menuItem.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel the operation
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteMenuItem(menuItem); // Call deleteMenuItem with MenuItem
              },
              child: Text('Confirm'),
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
          title: Text('Add Menu Item'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
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
              child: Text('Confirm'),
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
          title: Text('My Menus'),
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
                decoration: InputDecoration(
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
                    title: Text('${menuItem.name} - ${menuItem.price} INR'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editMenuItem(menuItem);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            handleDelete(menuItem); // Pass the MenuItem you want to delete
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
          child: Icon(Icons.add),
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
        ),
      );
    }
  }


