import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miel_app/models/user.dart';
import 'package:miel_app/pages/login_web.dart';
import 'package:miel_app/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  String _selectedRole = 'Admin';

  void _register() async {
    try {
      final newUser = User(
        id: '',
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
        number: _numberController.text,
        role: _selectedRole,
      );

      await UserService.registerUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green.shade300),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e'), backgroundColor: Colors.red.shade300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8),
          child: Column(
            children: [
              MenuBar(),
              _buildRegisterBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Account',
                  style: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "If you have an account",
                  style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Sign In here!",
                    style: TextStyle(color: Colors.orange.shade300, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/signin-unscreen.gif',
                  width: 300,
                ),
              ],
            ),
          ),
        ),

        // Form Section
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 10),
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 5, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SIGN UP', style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange.shade300)),
                  SizedBox(height: 20),
                  _buildTextField(controller: _nameController, label: 'Name', icon: Icons.person, hintText: 'Ex: John Doe'),
                  _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email, hintText: 'Ex: john.doe@example.com'),
                  _buildTextField(controller: _passwordController, label: 'Password', icon: Icons.lock, obscureText: true, hintText: 'Enter your password'),
                  _buildTextField(controller: _addressController, label: 'Address', icon: Icons.location_on, hintText: 'Ex: 123 Rue de Paris'),
                  _buildTextField(controller: _numberController, label: 'Phone Number', icon: Icons.phone, hintText: 'Ex: +1234567890'),
                  _buildRoleDropdown(),
                  SizedBox(height: 20),
                  _buildRegisterButton(),
                  SizedBox(height: 20),                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      child: Text("REGISTER", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[500]),
            hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
       style: GoogleFonts.poppins(color: Colors.grey[500]),
      value: _selectedRole,
      onChanged: (value) => setState(() => _selectedRole = value!),
      decoration: InputDecoration(
        labelText: 'Role',
        labelStyle: GoogleFonts.poppins(color: Colors.grey[500]),
         hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: ['Client', 'Admin'].map((role) => DropdownMenuItem(value: role,
       child: Text(role,
        style: GoogleFonts.poppins(color: Colors.grey[500]), ))).toList(),
    );
  }
}

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              _menuItem(title: 'Sign In'),
              _menuItem(title: 'Sign Up', isActive: true),
            ],
          )
         ]),
    );
  }

  Widget _menuItem({required String title, bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }
}
