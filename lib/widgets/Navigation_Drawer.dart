import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNavigationDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  AppNavigationDrawer({required this.onItemSelected});

  @override
  _AppNavigationDrawerState createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  int _selectedIndex = 0;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Guest';
    });
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.orange.shade100,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 50),
                Text(_userName, style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          _buildListTile("Dashboard", Icons.dashboard, 0),
          _buildListTile("Users", Icons.person, 1),
          _buildListTile("Orders", Icons.shopping_cart, 2),
          _buildListTile("Categories", Icons.category, 3),
          _buildListTile("Products", Icons.production_quantity_limits, 4),
          _buildListTile("Stock Management", Icons.inventory, 5),
          _buildListTile("Reports", Icons.report, 6),
          _buildListTile("Settings", Icons.settings, 7),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, int index) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.orange.shade300,
      onTap: () => _onTap(index),
    );
  }
}
