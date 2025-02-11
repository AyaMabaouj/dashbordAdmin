import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miel_app/pages/admin_dashboard.dart';
import 'package:miel_app/pages/register_web.dart';
import 'package:miel_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

void _login() async {
  try {
    final response = await UserService.loginUser(
      _emailController.text,
      _passwordController.text,
    );
    
    // Save the user data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', response['user']['name']); // Save the user's name
    prefs.setString('token', response['token']); // Save the token
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful'),
        backgroundColor: Colors.green.shade300,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login failed: $e'),
        backgroundColor: Colors.red.shade300,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          MenuBar(),
          _buildLoginBody(),
        ],
      ),
    );
  }

  Widget _buildLoginBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side illustration
        Container(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In to \nMiel App Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "If you don't have an account",
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()), // Replace with your RegisterPage widget
                    );                },
                child: Text(
                  "Register here!",
                  style: TextStyle(
                    color: Colors.orange.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/sign-up.gif',
                width: 300,
              ),
            ],
          ),
        ),

        // Login Form
        Padding(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 6),
          child: Container(
            width: 350,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SIGN IN',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade300,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  hintText: 'Ex: john.doe@example.com',
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  hintText: 'Votre mot de passe',
                ),
                SizedBox(height: 20),
                _buildSignInButton(),
                SizedBox(height: 20),
                _buildSocialLogin(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _login,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            "SIGN IN",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300], height: 50)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Or continue with", style: GoogleFonts.poppins()),
            ),
            Expanded(child: Divider(color: Colors.grey[400], height: 50)),
          ],
        ),
        SizedBox(height: 20),
            Center(child: _socialLoginButton('assets/images/google.png', isActive: true)),
  
        
      ],
    );
  }

  Widget _socialLoginButton(String image, {bool isActive = false}) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isActive
            ? [BoxShadow(color: Colors.grey[300]!, spreadRadius: 5, blurRadius: 15)]
            : [],
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Center(
        child: Image.asset(image, width: 35),
      ),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
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
              _menuItem(title: 'Sign In', isActive: true),
              _menuItem(title: 'Sign Up'),
            ],
          ),
        ],
      ),
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
