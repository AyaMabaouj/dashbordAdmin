import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardHeader extends StatefulWidget {
  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String _userName = 'Admin';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Admin';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          SizedBox(width: 16.0),
          Row(
            children: [
              Text(_userName, style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(width: 16.0),
          CircleAvatar(
            backgroundImage: AssetImage('assets/Images/profil.png'),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
