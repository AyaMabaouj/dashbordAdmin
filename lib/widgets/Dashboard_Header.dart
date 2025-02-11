import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
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
          CircleAvatar(
            backgroundImage: AssetImage('assets/Images/profil.png'),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}