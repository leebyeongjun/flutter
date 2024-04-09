import 'package:flutter/material.dart';
import 'package:flutter_login/components/logo.dart';
import 'package:flutter_login/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordCheckController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Logo("애니멀봐"),
              SizedBox(height: 40),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.person),
                  errorText: _errorMessage.isNotEmpty && _idController.text.isEmpty
                      ? 'Please fill out ID.'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  errorText: _errorMessage.isNotEmpty && _passwordController.text.isEmpty
                      ? 'Please fill out Password.'
                      : null,
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordCheckController,
                decoration: InputDecoration(
                  labelText: 'Password Check',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.check_circle),
                  errorText: _errorMessage.isNotEmpty && _passwordCheckController.text.isEmpty
                      ? 'Please fill out Password Check.'
                      : _passwordController.text != _passwordCheckController.text
                      ? 'Password and Password Check do not match.'
                      : null,
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _errorMessage.isNotEmpty && _userNameController.text.isEmpty
                      ? 'Please fill out User Name.'
                      : null,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _validateAndSignUp(context);
                },
                style: ButtonStyle( // 버튼 스타일 설정
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 60)),
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSignUp(BuildContext context) {
    if (_idController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordCheckController.text.isEmpty ||
        _userNameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill out all fields.';
      });
    } else if (_passwordController.text != _passwordCheckController.text) {
      setState(() {
        _errorMessage = 'Password and Password Check do not match.';
      });
    } else {
      setState(() {
        _errorMessage = '';
      });
      _performSignUp(context);
    }
  }

  void _performSignUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Sign up successful!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}