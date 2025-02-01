import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miel_app/models/user.dart';
import 'package:miel_app/services/user_service.dart';

class UsersScreen extends StatelessWidget {
  final RxBool isLoading = true.obs; // To manage the loading state
  final List<User> users = []; // To store the list of users

  UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch users asynchronously
    _fetchUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Enables horizontal scrolling if needed
          child: Card(
            elevation: 5,  // White elevation effect
            color: Colors.white,  // White background for better visibility
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),  // Rounded corners for the card
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                columns: const [
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text(user.name)),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.address ?? 'No Address')),
                      DataCell(Text(user.number ?? 'No Number')),
                      DataCell(Text(user.role)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Implement the edit user dialog here
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await UserService.deleteUser(user.id);
                              _fetchUsers();  // Refresh the list
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add user functionality here
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add User',
      ),
    );
  }

  // Function to fetch users
  void _fetchUsers() async {
    isLoading.value = true;
    try {
      users.clear();  // Clear previous data
      final fetchedUsers = await UserService.getAllUsers();  // Fetch from backend
      users.addAll(fetchedUsers);
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
