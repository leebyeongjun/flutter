import 'package:flutter/material.dart';
import 'package:flutter_login/components/custom_form.dart';
import 'package:flutter_login/components/logo.dart';
import 'package:flutter_login/size.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: xlarge_gap),
            const Logo("애니멀봐"),
            const SizedBox(height: large_gap),
            CustomForm(),
          ],
        ),
      ),
    );
  }
}
