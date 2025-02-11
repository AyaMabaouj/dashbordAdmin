import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miel_app/widgets/Dashboard_Header.dart';
import 'package:miel_app/widgets/Metric_Card.dart';
import 'package:miel_app/widgets/Sales_Chart.dart';
import 'package:miel_app/widgets/Navigation_Drawer.dart';
import 'package:miel_app/pages/category_list.dart';
import 'package:miel_app/pages/orders_page.dart';
import 'package:miel_app/pages/products_page.dart';
import 'package:miel_app/pages/users_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Keep track of selected page index

  final List<String> _pageTitles = [
    'Dashboard',
    'Users',
    'Orders',
    'Categories',
    'Products',
    'Stock Management',
    'Reports',
    'Settings'
  ];

  final List<Widget> _pages = [
    DashboardContent(),
    UsersScreen(),
    OrdersScreen(),
    CategoriesScreen(),
    ProductListPage(),
    Center(child: Text("Stock Management Content")),
    Center(child: Text("Reports Content")),
    Center(child: Text("Settings Content")),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 254, 172, 64),
      body: Row(
        children: [
          // Sidebar Navigation Drawer
          AppNavigationDrawer(onItemSelected: _onItemSelected),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Dynamic Header
                DashboardHeader(),
                // Display corresponding page
                Expanded(
                  child: _pages[_currentIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                MetricCard(
                  title: 'Total Sales',
                  value: '\$12,345',
                  icon: Icons.attach_money,
                  color: Colors.blue,
                ),
                MetricCard(
                  title: 'Total Orders',
                  value: '1,234',
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                ),
                MetricCard(
                  title: 'Customers',
                  value: '5,678',
                  icon: Icons.people,
                  color: Colors.green,
                ),
                MetricCard(
                  title: 'Conversion Rate',
                  value: '12.34%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
                SalesChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
