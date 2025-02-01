import 'package:flutter/material.dart';
import 'package:miel_app/pages/category_list.dart';
import 'package:miel_app/pages/orders_page.dart';
import 'package:miel_app/pages/products_page.dart';
import 'package:miel_app/pages/users_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Keep track of the selected index

  // List of widgets for each page
  final List<Widget> _pages = [
    Center(child: Text("Dashboard Content")),
    UsersScreen(),
    OrdersScreen(),
    CategoriesScreen(),
    ProductListPage(), // Your product page
    Center(child: Text("Stock Management Content")),
    Center(child: Text("Reports Content")),
    Center(child: Text("Settings Content")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Admin Dashboard",
            style: TextStyle(color: Colors.white), // Change text color to white
          ),        backgroundColor: const Color.fromARGB(255, 253, 165, 33),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.orange.shade100,
            child: Column(
              children: [
                ListTile(
                  title: Text("Dashboard"),
                  leading: Icon(Icons.dashboard),
                  onTap: () {
                    setState(() {
                      _currentIndex = 0; // Set the index to show the Dashboard content
                    });
                  },
                ),
                 ListTile(
                  title: Text("Users"),
                  leading: Icon(Icons.person),
                  onTap: () {
                    setState(() {
                      _currentIndex = 1; // Set the index to show the Orders content
                    });
                  },
                ),
                ListTile(
                  title: Text("Orders"),
                  leading: Icon(Icons.shopping_cart),
                  onTap: () {
                    setState(() {
                      _currentIndex = 2; // Set the index to show the Orders content
                    });
                  },
                ),
                    ListTile(
                  title: Text("Category"),
                  leading: Icon(Icons.category),
                  onTap: () {
                    setState(() {
                      _currentIndex = 3; // Set the index to show the Products content
                    });
                  },
                ),
                ListTile(
                  title: Text("Products"),
                  leading: Icon(Icons.production_quantity_limits),
                  onTap: () {
                    setState(() {
                      _currentIndex = 4; // Set the index to show the Products content
                    });
                  },
                ),
                ListTile(
                  title: Text("Stock Management"),
                  leading: Icon(Icons.inventory),
                  onTap: () {
                    setState(() {
                      _currentIndex = 5; // Set the index to show the Stock Management content
                    });
                  },
                ),
                ListTile(
                  title: Text("Reports"),
                  leading: Icon(Icons.report),
                  onTap: () {
                    setState(() {
                      _currentIndex = 6; // Set the index to show the Reports content
                    });
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    setState(() {
                      _currentIndex = 7; // Set the index to show the Settings content
                    });
                  },
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _pages[_currentIndex], // Show the current page based on the selected index
            ),
          ),
        ],
      ),
    );
  }
}
