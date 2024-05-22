import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class HalamanProfile extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<HalamanProfile> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  late String _email = '';
  late String _password = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    setState(() {
      _email = savedEmail ?? '';
      _password = savedPassword ?? '';
    });
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
      _isEditing = false;
      _updateLastLoginAutofill();
    });
  }

  Future<void> _updateLastLoginAutofill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastEmail', _emailController.text);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing
                ? _saveUserData
                : () => setState(() => _isEditing = true),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                if (!_isEditing) return;
                _updateLastLoginAutofill();
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                if (!_isEditing) return;
                _updateLastLoginAutofill();
              },
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
