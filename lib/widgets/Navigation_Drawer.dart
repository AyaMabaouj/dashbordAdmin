import 'package:flutter/material.dart';
import 'package:miel_app/pages/login_web.dart';
import '../services/user_service.dart';

class AppNavigationDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  const AppNavigationDrawer({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  _AppNavigationDrawerState createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  Future<void> _logout() async {
    try {
      await UserService.logoutUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Logout failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color.fromARGB(255, 44, 44, 44),
      child: Column(
        children: [
          // Logo amélioré avec un fond clair et un padding
          DrawerHeader(
            child: Container(
             
              padding: EdgeInsets.all(8),
              child: Image.asset('assets/images/logoappl.png', height: 100),
            ),
          ),
          Expanded(
            child: Column(
              children: [
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
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: _logout,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.orangeAccent : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      leading: Icon(
        icon,
        color: isSelected ? Colors.orangeAccent : Colors.white,
        size: isSelected ? 28 : 24, // Agrandir légèrement l'icône sélectionnée
      ),
      selected: isSelected,
      selectedTileColor: Colors.orange.shade400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Ajout d'un effet de surbrillance
      ),
      onTap: () => _onTap(index),
    );
  }
}
